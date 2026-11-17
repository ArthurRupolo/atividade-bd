"""Gera os 2 PDFs (modelo UniSENAI) a partir de banco_tv.sql e consultas.sql.
Uso: python3 gerar_pdfs.py   (as consultas são executadas em SQLite só para obter os resultados)"""
import re, sqlite3, textwrap

NOME = "Arthur Rupolo da Costa"

criacao = open("banco_tv.sql", encoding="utf-8").read()
consultas = open("consultas.sql", encoding="utf-8").read()

# ---------------------------------------------------------------- banco (conferência)
db = sqlite3.connect(":memory:")
db.execute("PRAGMA foreign_keys=ON")
db.executescript("\n".join(l for l in criacao.splitlines()
                           if not l.startswith(("CREATE DATABASE", "\\c"))))
assert not db.execute("PRAGMA foreign_key_check").fetchall()

# ---------------------------------------------------------------- PDF mínimo
W, H, M = 595, 842, 55
AZUL, CLARO = (0, 0.29, 0.6), (0.82, 0.9, 1.0)
F = {"n": "F1", "b": "F2", "c": "F3", "l": "F4"}


def tw(s, size, bold=False):
    return len(s) * size * (0.56 if bold else 0.52)


class Doc:
    def __init__(self):
        self.pages, self.ops, self.y = [], None, 0
        self.new()

    def new(self):
        self.ops = []
        self.pages.append(self.ops)
        self.text("UniSENAi", W - M - 100, H - 52, 24, "l", AZUL)
        self.y = H - 100

    def text(self, s, x, y, size=10, f="n", color=(0, 0, 0)):
        s = s.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")
        self.ops.append(f"{color[0]} {color[1]} {color[2]} rg BT /{F[f]} {size} Tf {x:.1f} {y:.1f} Td ({s}) Tj ET")

    def rect(self, x, y, w, h, fill=None, stroke=False):
        if fill:
            self.ops.append(f"{fill[0]} {fill[1]} {fill[2]} rg {x:.1f} {y:.1f} {w:.1f} {h:.1f} re f")
        if stroke:
            self.ops.append(f"0 0 0 RG 0.5 w {x:.1f} {y:.1f} {w:.1f} {h:.1f} re S")

    def need(self, h):
        if self.y - h < 50:
            self.new()

    def centered(self, s, size, f="n"):
        self.text(s, (W - tw(s, size, f == "b")) / 2, self.y, size, f)
        self.y -= size + 8

    def label(self, rot, val):
        self.text(rot + ":", M, self.y, 10, "b")
        self.text(val, M + tw(rot + ":", 10, True) + 4, self.y, 10)
        self.y -= 15

    def topico(self, s, size=12, x=M + 15):
        self.need(70)
        self.y -= 10
        self.text(s, x, self.y, size, "b")
        self.y -= size + 8

    def codigo(self, txt, largura=98):
        for ln in txt.splitlines():
            for w in (textwrap.wrap(ln, largura, subsequent_indent="    ") or [""]):
                self.need(12)
                self.rect(M, self.y - 3, W - 2 * M, 11.5, (0.95, 0.95, 0.95))
                self.text(w, M + 3, self.y, 8, "c")
                self.y -= 11.5
        self.y -= 6

    def tabela(self, cols, rows):
        cw = [max(len(c), *(len(r[i]) for r in rows)) * 4.7 + 12 for i, c in enumerate(cols)]
        tot = W - 2 * M
        if sum(cw) > tot:
            k = tot / sum(cw)
            cw = [max(45, c * k) for c in cw]
            k = tot / sum(cw)
            cw = [c * k for c in cw]
        else:
            cw = [c * min(1.4, tot / sum(cw)) for c in cw]

        def linhas(r):
            return [textwrap.wrap(v, max(4, int((cw[i] - 8) / 4.7))) or [""] for i, v in enumerate(r)]

        def desenha(r, h, fill, cor, f):
            x = M
            for i, partes in enumerate(linhas(r) if f == "n" else [[c] for c in r]):
                self.rect(x, self.y - h + 4, cw[i], h, fill, True)
                for j, p in enumerate(partes):
                    self.text(p, x + 4, self.y - 7 - j * 10, 8.5, f, cor)
                x += cw[i]
            self.y -= h

        def cab():
            desenha(cols, 18, AZUL, (1, 1, 1), "b")

        self.need(60)
        cab()
        for k, r in enumerate(rows):
            h = max(len(p) for p in linhas(r)) * 10 + 8
            if self.y - h < 50:
                self.new()
                cab()
            desenha(r, h, CLARO if k % 2 else None, (0, 0, 0), "n")
        self.y -= 10

    def salvar(self, arq):
        obj = ["<< /Type /Catalog /Pages 2 0 R >>", ""]
        for b in ("Helvetica", "Helvetica-Bold", "Courier", "Helvetica-BoldOblique"):
            obj.append(f"<< /Type /Font /Subtype /Type1 /BaseFont /{b} /Encoding /WinAnsiEncoding >>")
        kids = []
        for n, ops in enumerate(self.pages, 1):
            ops = ops + [f"0 g BT /F1 10 Tf {W - M - 6} 30 Td ({n}) Tj ET"]
            st = "\n".join(ops)
            obj.append(f"<< /Length {len(st.encode('cp1252', 'replace'))} >>\nstream\n{st}\nendstream")
            kids.append(len(obj) + 1)
            obj.append(f"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 {W} {H}] /Contents {len(obj)} 0 R "
                       "/Resources << /Font << /F1 3 0 R /F2 4 0 R /F3 5 0 R /F4 6 0 R >> >> >>")
        obj[1] = f"<< /Type /Pages /Kids [{' '.join(f'{k} 0 R' for k in kids)}] /Count {len(kids)} >>"
        out, pos = b"%PDF-1.4\n", []
        for i, o in enumerate(obj, 1):
            pos.append(len(out))
            out += f"{i} 0 obj\n".encode() + o.encode("cp1252", "replace") + b"\nendobj\n"
        x = len(out)
        out += f"xref\n0 {len(obj) + 1}\n0000000000 65535 f \n".encode()
        out += b"".join(f"{p:010d} 00000 n \n".encode() for p in pos)
        out += f"trailer\n<< /Size {len(obj) + 1} /Root 1 0 R >>\nstartxref\n{x}\n%%EOF".encode()
        open(arq, "wb").write(out)
        print(arq, len(self.pages), "paginas")


def capa(titulo_atividade):
    d = Doc()
    d.y -= 5
    d.centered("Centro Universitário SENAI - UniSENAI Campus Florianópolis", 14, "b")
    d.centered("Curso de Ciência de Dados e Inteligência Artificial", 11)
    d.y -= 8
    d.label("Unidade Curricular", "Banco de dados I")
    d.label("Professor", "Gustavo Stangherlin Cantarelli")
    d.label("Ano/Semestre", "2026/2")
    d.y -= 6
    d.label("Nome", NOME)
    d.label("Atividade", titulo_atividade)
    return d


# ================================================================ PDF 1 - banco e inserts
d = capa("Atividade Individual 1 - Implementação do banco BD_TV_FILMES (PostgreSQL)")
tabelas = re.findall(r"CREATE TABLE (\w+) \(.*?\n\);", criacao, re.S)
d.topico("1. Criação do banco de dados e das tabelas")
d.codigo("CREATE DATABASE bd_tv_filmes;\n\\c bd_tv_filmes")
for ddl in re.findall(r"CREATE TABLE .*?\n\);", criacao, re.S):
    d.codigo(ddl)

d.topico("2. Tabelas e seus inserts")
inserts = re.findall(r"INSERT INTO (\w+) .*?;\n", criacao + "\n", re.S)
stm = re.findall(r"(INSERT INTO (\w+) .*?;)\n", criacao + "\n", re.S)
resumo = []
for i, t in enumerate(tabelas, 1):
    n = db.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
    resumo.append([t, str(n), "Associativa" if t in
                   ("avaliacao", "pro_elenco", "prog_genero", "disponibilidade") else "Comum"])
    d.topico(f"2.{i} Tabela: {t} ({n} registros)", 11, M + 30)
    for s, nome in stm:
        if nome == t:
            d.codigo(s)

d.topico("APÊNDICES", 12, M)
d.topico("APÊNDICE A - Quantidade de registros por tabela", 11, M)
d.tabela(["tabela", "registros", "tipo"], resumo)
d.salvar("Atividade1_Criacao_e_Inserts.pdf")

# ================================================================ PDF 2 - consultas
d = capa("Atividade Individual 2 - Consultas do banco BD_TV_FILMES")
d.topico("1. Consultas e resultados")
for bloco in re.split(r"(?m)^(?=-- Questão)", consultas)[1:]:
    cab, *corpo = bloco.strip().splitlines()
    sql = "\n".join(corpo)
    cur = db.execute(sql)
    cols = [c[0] for c in cur.description]
    rows = [["" if v is None else str(v) for v in r] for r in cur.fetchall()]
    d.need(110)
    d.text(cab.replace("-- ", "", 1), M, d.y, 10.5, "b")
    d.y -= 16
    d.codigo("\n".join(l for l in sql.splitlines() if not l.startswith("--")))
    d.text(f"Resultado ({len(rows)} linha(s)):", M, d.y, 9.5, "b")
    d.y -= 14
    if rows:
        d.tabela(cols, rows)
    else:
        d.text("(nenhum registro)", M, d.y, 9)
        d.y -= 18
d.salvar("Atividade2_Consultas.pdf")
