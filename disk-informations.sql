

SELECT 
    mount_point,
    file_system,
    file_system_type,  
    
    -- shows as MB 
    ROUND(total_space::numeric / 1024 / 1024, 2) AS total_mb,
    ROUND(used_space::numeric / 1024 / 1024, 2) AS used_mb,
    ROUND(free_space::numeric / 1024 / 1024, 2) AS free_mb,
    
    -- shows as GB 
    ROUND(total_space::numeric / 1024 / 1024 / 1024, 2) AS total_gb,
    ROUND(used_space::numeric / 1024 / 1024 / 1024, 2) AS used_gb,
    ROUND(free_space::numeric / 1024 / 1024 / 1024, 2) AS free_gb,
    
    -- Usage percentages
    ROUND(used_space::numeric / NULLIF(total_space, 0) * 100, 2) AS kullanim_pct,
    
    -- Free Space 
    ROUND(free_space::numeric / NULLIF(total_space, 0) * 100, 2) AS bos_pct,
    
    -- İnode bilgisi
    total_inodes,
    used_inodes,
    free_inodes,
    ROUND(used_inodes::numeric / NULLIF(total_inodes, 0) * 100, 2) AS inode_kullanim_pct

FROM pg_sys_disk_info()
ORDER BY mount_point;
