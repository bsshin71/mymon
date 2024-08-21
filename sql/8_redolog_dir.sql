 select case @@innodb_log_group_home_dir
        when './' then  concat(@@datadir,'#innodb_redo')
        else concat(@@innodb_log_group_home_dir,'#innodb_redo')
        end  as redo_dir
