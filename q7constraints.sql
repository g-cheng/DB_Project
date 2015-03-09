
-- Event date cannot be earlier than current date
ALTER TABLE event ADD CHECK (eventDate > CURRENT_DATE);