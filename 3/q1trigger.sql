-- function that gets called everytime the trigger below is activated
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


/* RESULTS

-- prerequisite: create a service entity
bookface=# insert into service (serviceID) values (200);
INSERT 0 1

-- trigger pulled when trying to insert a avi video with filesize larger or equal to 5000
bookface=# insert into video (videoID, serviceID, format, filesize) values (200,200,'avi',8000);
ERROR:  avi videos cannot exceed 5000 in size

-- trigger not pulled when trying to insert a avi video with filesize less than 5000
bookface=# insert into video (videoID, serviceID, format, filesize) values (200,200,'avi',50);
INSERT 0 1


-- prerequisite: create a service entity
bookface=# insert into service (serviceID) values (201);
INSERT 0 1

-- trigger pulled when trying to insert a mkv video with filesize larger or equal to 6000
bookface=# insert into video (videoID, serviceID, format, filesize) values (201,201,'mkv',8000);
ERROR:  mkv videos cannot exceed 6000 in size

-- trigger not pulled when trying to insert a mkv video with filesize less than 6000
bookface=# insert into video (videoID, serviceID, format, filesize) values (201,201,'mkv',50);
INSERT 0 1


-- prerequisite: create a service entity
bookface=# insert into service (serviceID) values (202);
INSERT 0 1

-- trigger pulled when trying to insert a mp4 video with filesize larger or equal to 4000
bookface=# insert into video (videoID, serviceID, format, filesize) values (202,202,'mp4',8000);
ERROR:  mp4 videos cannot exceed 4000 in size

-- trigger not pulled when trying to insert a mp4 video with filesize less than 4000
bookface=# insert into video (videoID, serviceID, format, filesize) values (202,202,'mp4',50);
INSERT 0 1


*/