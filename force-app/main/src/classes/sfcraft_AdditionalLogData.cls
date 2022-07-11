public interface sfcraft_AdditionalLogData {
    SObject enrichLog(SObject logRecord);
    void setField(String fieldName, Object fieldValue);
    Object getField(String fieldName);
}
