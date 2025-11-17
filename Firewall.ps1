# Caminho do relatório central
$Relatorio = "\\SERVIDOR\relatorio$\Status_Firewall.csv"

# Inicializa variáveis
$DomainStatus = $PrivateStatus = $PublicStatus = $StatusGeral = "Erro"
$UsuarioLogado = "N/A"

# Coleta usuário logado (se existir)
try {
    $UsuarioLogado = (Get-WmiObject Win32_ComputerSystem).UserName
} catch {}

try {
    # 🔹 Tentativa 1 — método CIM (com MSFT_NetFirewallProfile)
    $fwProfiles = Get-CimInstance -Namespace "root/StandardCimv2" -ClassName MSFT_NetFirewallProfile -ErrorAction Stop

    $DomainStatus  = ($fwProfiles | Where-Object Name -eq "Domain").Enabled
    $PrivateStatus = ($fwProfiles | Where-Object Name -eq "Private").Enabled
    $PublicStatus  = ($fwProfiles | Where-Object Name -eq "Public").Enabled

    $StatusGeral = if ($DomainStatus -or $PrivateStatus -or $PublicStatus) { "Ativado" } else { "Desativado" }
}
catch {
    try {
        # 🔹 Tentativa 2 — método WMI (status geral)
        $fwProduct = Get-WmiObject -Namespace "root\CIMV2" -Class Win32_FirewallProduct -ErrorAction Stop
        if ($fwProduct) {
            $StatusGeral = "Ativado"
        }
        else {
            $StatusGeral = "Desativado ou não detectado"
        }
    }
    catch {
        $StatusGeral = "Erro"
    }
}

# Monta o resultado
$resultado = [PSCustomObject]@{
    DataHora         = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
    Computador       = $env:COMPUTERNAME
    UsuarioLogado    = $UsuarioLogado
    Firewall_Domain  = switch ($DomainStatus)  { $true {"Ativado"}; $false {"Desativado"}; Default {"N/A"} }
    Firewall_Private = switch ($PrivateStatus) { $true {"Ativado"}; $false {"Desativado"}; Default {"N/A"} }
    Firewall_Public  = switch ($PublicStatus)  { $true {"Ativado"}; $false {"Desativado"}; Default {"N/A"} }
    Firewall_Geral   = $StatusGeral
}

# 🔹 Grava resultado no servidor central (append seguro)
try {
    if (Test-Path $Relatorio) {
        $resultado | Export-Csv -Path $Relatorio -Append -NoTypeInformation -Encoding UTF8
    } else {
        $resultado | Export-Csv -Path $Relatorio -NoTypeInformation -Encoding UTF8
    }
}
catch {
    # Falha ao gravar no servidor — ignora
}

# 🔹 Retorna também o resultado ao console do SCCM
$resultado
