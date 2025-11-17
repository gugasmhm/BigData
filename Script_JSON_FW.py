import json
import pandas as pd

# Exemplo da linha de entrada (você pode trocar por leitura de arquivo)
linha = """DSKCCPASP000057\t1\t0\t{
  "DataHora": "2025-11-17 12:32:53",
  "Computador": "DSKCCPASP000057",
  "UsuarioLogado": "TAHTO\\\\TH800734",
  "Firewall_Domain": "N/A",
  "Firewall_Private": "N/A",
  "Firewall_Public": "N/A",
  "Firewall_Geral": "Ativado"
}"""

# ------------------------------------------------------------
# 1. Separar campos da linha (Tudo até o JSON são campos TAB)
# ------------------------------------------------------------
partes = linha.split("\t", 3)  # separa só nos 3 primeiros TABs
campo1 = partes[0]
campo2 = partes[1]
campo3 = partes[2]
json_str = partes[3]

# ------------------------------------------------------------
# 2. Converter o JSON para dicionário Python
# ------------------------------------------------------------
dados_json = json.loads(json_str)

# ------------------------------------------------------------
# 3. Mesclar os campos fixos com o JSON
# ------------------------------------------------------------
registro = {
    "Computador_Campo": campo1,
    "Valor1": campo2,
    "Valor2": campo3,
}
registro.update(dados_json)

# ------------------------------------------------------------
# 4. Criar uma tabela (DataFrame)
# ------------------------------------------------------------
df = pd.DataFrame([registro])

# ------------------------------------------------------------
# 5. Exibir a tabela formatada
# ------------------------------------------------------------
print(df.to_string(index=False))
