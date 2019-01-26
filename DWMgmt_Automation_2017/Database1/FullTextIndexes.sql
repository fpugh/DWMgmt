﻿CREATE FULLTEXT INDEX ON [CAT].[REG_0600_Object_Code_Library]
    ([REG_Code_Content] LANGUAGE 1033)
    KEY INDEX [UQ_REG_0600_ID]
    ON [CodeContent]
    WITH STOPLIST OFF;

