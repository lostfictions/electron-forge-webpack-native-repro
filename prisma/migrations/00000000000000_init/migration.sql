-- CreateTable
CREATE TABLE "Pin" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "url" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "ctime" DATETIME NOT NULL,
    "mtime" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "tag" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_PinToTag" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,
    FOREIGN KEY ("A") REFERENCES "Pin" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("B") REFERENCES "Tag" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Pin.url_unique" ON "Pin"("url");

-- CreateIndex
CREATE UNIQUE INDEX "Tag.tag_unique" ON "Tag"("tag");

-- CreateIndex
CREATE UNIQUE INDEX "_PinToTag_AB_unique" ON "_PinToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_PinToTag_B_index" ON "_PinToTag"("B");

-- ----------------
-- MANUALLY ADDED
CREATE VIRTUAL TABLE fts_idx USING fts5(url, title, body, content='Pin', content_rowid='id', tokenize='porter unicode61 remove_diacritics 2');

CREATE TRIGGER tbl_ai AFTER INSERT ON 'Pin' BEGIN
  INSERT INTO fts_idx(rowid, url, title, body) VALUES (new.id, new.url, new.title, new.body);
END;
CREATE TRIGGER tbl_ad AFTER DELETE ON 'Pin' BEGIN
  INSERT INTO fts_idx(fts_idx, rowid, url, title, body) VALUES('delete', old.id, old.url, old.title, old.body);
END;
CREATE TRIGGER tbl_au AFTER UPDATE ON 'Pin' BEGIN
  INSERT INTO fts_idx(fts_idx, rowid, url, title, body) VALUES('delete', old.id, old.url, old.title, old.body);
  INSERT INTO fts_idx(rowid, url, title, body) VALUES (new.id, new.url, new.title, new.body);
END;


