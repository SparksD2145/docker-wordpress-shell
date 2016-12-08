SET @host = 'https://skeleton.devel';
SET @prefix = 'wp_';

SET @wp_dev_id = '9001';
SET @wp_dev_user = 'developer';
SET @wp_dev_passwd = 'developer';
SET @wp_dev_name = 'Developer Account';
SET @wp_dev_email = 'developer@test.test';
SET @wp_dev_host = '';

SET @table_options = CONCAT(@prefix, "options");
SET @table_users = CONCAT(@prefix, "users");
SET @table_usermeta = CONCAT(@prefix, "usermeta");

DELIMITER //
CREATE PROCEDURE `do_task`(IN sql_text TEXT)
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        SET @SQL := sql_text;
        PREPARE stmt FROM @SQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END;
//
DELIMITER ;

/* change wp host */
CALL do_task(CONCAT("UPDATE ", @table_options, " SET `option_value` = ", @host, " WHERE option_name = 'home' OR option_name = 'siteurl'"));

/* build development administrator */
CALL do_task(CONCAT("INSERT INTO ", @table_users, " (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_url`, `user_registered`, `user_activation_key`, `user_status`, `display_name`) VALUES (", @wp_dev_id, ",", @wp_dev_user, ",", MD5(@wp_dev_passwd), ",", @wp_dev_name, ",", @wp_dev_email, ",", @wp_dev_host, ",", NOW(), ",", '', ",", '0', ",", @wp_dev_name, ");"));
CALl do_task(CONCAT("INSERT INTO ", @table_usermeta, " (`umeta_id`, `user_id`, `meta_key`, `meta_value`) VALUES (NULL, ", @wp_dev_id, ",", " 'wp_capabilities', 'a:1:{s:13:\"administrator\";s:1:\"1\";}');"));
CALL do_task(CONCAT("INSERT INTO ", @table_usermeta, "(`umeta_id`, `user_id`, `meta_key`, `meta_value`) VALUES (NULL, ", @wp_dev_id, ",", " 'wp_user_level', '10');"));
