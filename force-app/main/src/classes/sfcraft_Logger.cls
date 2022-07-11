public inherited sharing class sfcraft_Logger {

    private static sfcraft_Logger singleton;

    private String source;
    private Type additionalDataType;

    private static List<sfcraft_Log> storedLogs {
        get {
            if (null == storedLogs) {
                storedLogs = new List<sfcraft_Log>();
            }
            return storedLogs;
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
        this(source, null);
    }

    public sfcraft_Logger(Type additionalDataType) {
        this(null, additionalDataType);
    }

    public sfcraft_Logger(String source, Type additionalDataType) {
        this();
        this.source = source;
        this.additionalDataType = additionalDataType;
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
        if (null == source) {
            throw new IllegalArgumentException('Source is required for log');
        }
        sfcraft_AdditionalLogData additionalData;
        if (null != this.additionalDataType) {
            additionalData = (sfcraft_AdditionalLogData) this.additionalDataType.newInstance();
        }
        sfcraft_Log infoLog = new sfcraft_Log(source, additionalData);
        storedLogs.add(infoLog);
        return infoLog;
    }

    public sfcraft_Log createLog(Exception ex, String source) {
        sfcraft_Log errLog = this.createLog(source);
        errLog.setMessage(ex.getMessage());
        errLog.setDetails(ex.getStackTraceString());
        errLog.setSeverity(sfcraft_Log.Severities.ERROR);
        return errLog;
    }

    public sfcraft_Log createLog(Database.SaveResult dbSaveResult, String source) {
        sfcraft_Log errLog = this.createLog(source);
        errLog.setDetails(JSON.serialize(dbSaveResult.getErrors()));
        return errLog;
    }

    public static void insertLogs() {
        if(storedLogs != null && storedLogs.isEmpty() == False) {
            List<SObject> logsToInsert = new List<SObject>();
            for (sfcraft_Log nupayLog : storedLogs) {
                logsToInsert.add(nupayLog.getLogRecord());
            }
            // unsafe DML because anyone should be able to create logs
            insert logsToInsert;
            storedLogs.clear();
        }
    }

    public static List<sfcraft_Log> getStoredLogs() {
        return storedLogs;
    }
}
