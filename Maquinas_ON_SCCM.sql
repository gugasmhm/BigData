SELECT
    SYS.Name0 AS [Computer Name],
    SYS.User_Name0 AS [Last Logged User],
    COL.Name AS [Collection Name],
    CH.LastPolicyRequest AS [Policy Request],
    CH.LastDDR AS [Heartbeat DDR],
    HW.LastHW AS [Hardware Scan],
    SW.LastSW AS [Software Scan]
FROM v_FullCollectionMembership FCM
    INNER JOIN v_Collection COL ON FCM.CollectionID = COL.CollectionID
    INNER JOIN v_R_System SYS ON FCM.ResourceID = SYS.ResourceID
    LEFT JOIN v_CH_ClientSummary CH ON SYS.ResourceID = CH.ResourceID
    LEFT JOIN (
        SELECT ResourceID, MAX(LastHWScan) AS LastHW
        FROM v_GS_WORKSTATION_STATUS
        GROUP BY ResourceID
    ) HW ON SYS.ResourceID = HW.ResourceID
    LEFT JOIN (
        SELECT ResourceID, MAX(LastScanDate) AS LastSW
        FROM v_GS_LastSoftwareScan
        GROUP BY ResourceID
    ) SW ON SYS.ResourceID = SW.ResourceID
WHERE COL.Name = 'Maquinas sem Onda Notebook'
ORDER BY SYS.Name0;
