CREATE FUNCTION check_video() RETURNS trigger AS $check_video$

    BEGIN

        -- check if avi format videos exceed 5000 in size
        IF NEW.fileSize>=5000 AND NEW.format='avi' THEN
            RAISE EXCEPTION '% videos cannot exceed 5000 in size', NEW.format;
        END IF;
        -- check if mkv format videos exceed 6000 in size
        IF NEW.fileSize>=6000 AND NEW.format='mkv' THEN
            RAISE EXCEPTION '% videos cannot exceed 6000 in size', NEW.format;
        END IF;

        -- check if mp4 format videos exceed 4000 in size
        IF NEW.fileSize>=4000 AND NEW.format='mp4' THEN
            RAISE EXCEPTION '% videos cannot exceed 4000 in size', NEW.format;
        END IF;
        RETURN NEW;
    END;
$check_video$ LANGUAGE plpgsql;



-- a trigger that checks if the video sizes are below allowed limits
CREATE TRIGGER checkVideoSize BEFORE INSERT OR UPDATE ON video
    FOR EACH ROW EXECUTE PROCEDURE check_video();


/* example of actions triggering and not triggering the trigger and function above


bookface=# insert into service (serviceID) values (200);
INSERT 0 1
bookface=# insert into video (videoID, serviceID, format, filesize) values (200,200,'avi',8000);
ERROR:  avi videos cannot exceed 5000 in size
bookface=# insert into video (videoID, serviceID, format, filesize) values (200,200,'avi',50);
INSERT 0 1


*/