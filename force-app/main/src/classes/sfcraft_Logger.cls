public inherited sharing class sfcraft_Logger {
    private static List<sfcraft_Log> storedLogs {
        get {
            if (null == storedLogs) {
                storedLogs = new List<sfcraft_Log>();
            }
            return storedLogs;
        }
        set;
    }

    public static sfcraft_Log createLog(String scope) {
        sfcraft_Log infoLog = new sfcraft_Log(scope);
        storedLogs.add(infoLog);
        return infoLog;
    }

    public static sfcraft_Log createLog(Exception ex, String scope) {
        sfcraft_Log errLog = new sfcraft_Log(ex, scope);
        storedLogs.add(errLog);
        return errLog;
    }

    public static sfcraft_Log createLog(Database.SaveResult dbSaveResult, String scope) {
        sfcraft_Log errLog;
        errLog = sfcraft_Logger.createLog(scope);
        errLog.setDetails(JSON.serialize(dbSaveResult.getErrors()));
        storedLogs.add(errLog);
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
