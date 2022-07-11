public abstract class sfcraft_LoggableException extends Exception implements sfcraft_Loggable {

    public virtual sfcraft_Log log(sfcraft_Logger logger) {
        sfcraft_Log log = logger.createLog(this);
        return log;
    }

    public virtual sfcraft_Log log(String scource) {
        sfcraft_Log log = sfcraft_Logger.getSingleton().createLog(this, scource);
        return log;
    }
}
