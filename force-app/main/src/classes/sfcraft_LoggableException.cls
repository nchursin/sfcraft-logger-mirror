public abstract class sfcraft_LoggableException extends Exception implements sfcraft_Loggable {
    public virtual sfcraft_Log log(String scope) {
        sfcraft_Log log = sfcraft_Logger.createLog(this, scope);
        return log;
    }
}
