<#
.DESCRIPTION
    Lista todos os computadores da OU Estacoes (e sub-OUs) no domínio tahto.corp
    e exporta o resultado para C:\Relatorios\Relatorio_Estacoes.csv
#>

# Caminho da OU e do relatório
$OU = "OU=Estacoes,DC=tahto,DC=corp"
$ExportPath = "C:\Relatorios\Relatorio_Estacoes.csv"

# Garante que o módulo ActiveDirectory esteja disponível
Import-Module ActiveDirectory -ErrorAction Stop

# Cria a pasta de destino se não existir
if (!(Test-Path "C:\Relatorios")) {
    New-Item -ItemType Directory -Path "C:\Relatorios" | Out-Null
    Write-Host "Pasta C:\Relatorios criada." -ForegroundColor Yellow
}

Write-Host "Buscando computadores em $OU (incluindo sub-OUs)..." -ForegroundColor Cyan

try {
    # Busca recursiva de computadores
    $computers = Get-ADComputer -SearchBase $OU -SearchScope Subtree -Filter * -Properties Name, DNSHostName, OperatingSystem, LastLogonDate, Enabled, DistinguishedName

    if ($computers.Count -eq 0) {
        Write-Host "Nenhum computador encontrado na OU especificada." -ForegroundColor Yellow
    } else {
        # Seleciona os campos desejados
        $result = $computers | Select-Object `
            Name,
            DNSHostName,
            OperatingSystem,
            LastLogonDate,
            Enabled,
            @{Name="OrganizationalUnit";Expression={
                ($_.DistinguishedName -split ",",2)[1]
            }},
            DistinguishedName

        # Exibe no console
        $result | Format-Table -AutoSize

        # Exporta para CSV
        $result | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
        Write-Host "`nRelatório exportado com sucesso para: $ExportPath" -ForegroundColor Green
    }
}
catch {
    Write-Host "Erro ao buscar computadores: $_" -ForegroundColor Red
}
