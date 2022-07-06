public inherited sharing class sfcraft_Log {
    private static sfcraft_LogConfig config = new sfcraft_LogConfig();

    public enum Severities {
        ERROR,
        INFO,
        WARNING
    }

    private String message;
    private String stackTrace;
    private String source;
    private String scope;
    private Severities severity;

    public sfcraft_Log(String source) {
        this.source = source;
        this.severity = Severities.INFO;
    }

    public sfcraft_Log(Exception ex, String source) {
        this(source);
        this.setMessage(ex.getMessage());
        this.setDetails(ex.getStackTraceString());
        this.setSeverity(Severities.ERROR);
    }

    public SObject getLogRecord() {
        SObject record = config.getLogSObjectType().newSObject();
        record.put(config.getDetailsFieldName(), this.stackTrace);
        record.put(config.getMessageFieldName(), this.message);
        record.put(config.getSeverityFieldName(), this.severity);
        record.put(config.getSourceFieldName(), this.source);
        record.put(config.getScopeFieldName(), this.scope);
        return record;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public void setMessage(String message) {
        this.message = trimMessage(message);
    }

    public void setDetails(String details) {
        this.stackTrace = stackTrace;
    }

    public void setSeverity(Severities severity) {
        this.severity = severity;
    }

    private String trimMessage(String msg) {
        return String.isNotBlank(msg) ? msg.left(255) : null;
    }
}
