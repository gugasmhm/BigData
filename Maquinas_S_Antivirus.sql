SELECT 
    sys.Name0 AS 'ComputerName',
    sys.User_Name0 AS 'LastLoggedOnUser',
    sys.Operating_System_Name_and0 AS 'OS',
    ws.LastHWScan
FROM v_R_System AS sys
JOIN v_GS_WORKSTATION_STATUS AS ws
    ON sys.ResourceID = ws.ResourceID
WHERE sys.Client0 = 1
  AND ws.LastHWScan >= DATEADD(DAY, -30, GETDATE())
  AND sys.ResourceID NOT IN (
      SELECT arp.ResourceID
      FROM v_Add_Remove_Programs AS arp
      WHERE arp.DisplayName0 LIKE 'CrowdStrike%'
  )
ORDER BY sys.Name0
