SELECT 
    sys.Name0 AS [Computer Name],
    sys.User_Name0 AS [Last Logged On User],
    arp.DisplayName0 AS [Application Name],
    arp.Version0 AS [Version],
    sys.Operating_System_Name_and0 AS [Operating System],
    sys.Resource_Domain_OR_Workgr0 AS [Domain/Workgroup],
    sys.Client_Version0 AS [SCCM Client Version],
    sys.Last_Logon_Timestamp0 AS [Last Logon Timestamp]
FROM 
    v_Add_Remove_Programs AS arp
    INNER JOIN v_R_System AS sys ON arp.ResourceID = sys.ResourceID
WHERE 
    arp.DisplayName0 LIKE '%Crowdstrike%'
ORDER BY 
    sys.Name0
