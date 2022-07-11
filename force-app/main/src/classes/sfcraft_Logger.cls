public inherited sharing class sfcraft_Logger {

    private static sfcraft_Logger singleton;

    private String source;

    private List<sfcraft_Log> storedLogs {
        get {
            if (null == this.storedLogs) {
                this.storedLogs = new List<sfcraft_Log>();
            }
            return this.storedLogs;
        }
        set;
    }

    public static sfcraft_Logger getSingleton() {
        if (null == singleton) {
            singleton = new sfcraft_Logger();
        }
        return singleton;
    }

    public sfcraft_Logger() {
    }

    public sfcraft_Logger(String source) {
        this();
        this.source = source;
    }

    public sfcraft_Log createLog() {
        return this.createLog(this.source);
    }

    public sfcraft_Log createLog(Exception ex) {
        return this.createLog(ex, this.source);
    }

    public sfcraft_Log createLog(Database.SaveResult dbSaveResult) {
        return this.createLog(dbSaveResult, this.source);
    }

    public sfcraft_Log createLog(String source) {
        sfcraft_Log infoLog = new sfcraft_Log(source);
        this.storedLogs.add(infoLog);
        return infoLog;
    }

    public sfcraft_Log createLog(Exception ex, String source) {
        sfcraft_Log errLog = new sfcraft_Log(ex, source);
        this.storedLogs.add(errLog);
        return errLog;
    }

    public sfcraft_Log createLog(Database.SaveResult dbSaveResult, String source) {
        sfcraft_Log errLog;
        errLog = this.createLog(source);
        errLog.setDetails(JSON.serialize(dbSaveResult.getErrors()));
        this.storedLogs.add(errLog);
        return errLog;
    }

    public void insertLogs() {
        if(this.storedLogs != null && this.storedLogs.isEmpty() == False) {
            List<SObject> logsToInsert = new List<SObject>();
            for (sfcraft_Log nupayLog : this.storedLogs) {
                logsToInsert.add(nupayLog.getLogRecord());
            }
            // unsafe DML because anyone should be able to create logs
            insert logsToInsert;
            this.storedLogs.clear();
        }
    }

    public List<sfcraft_Log> getStoredLogs() {
        return this.storedLogs;
    }
}
