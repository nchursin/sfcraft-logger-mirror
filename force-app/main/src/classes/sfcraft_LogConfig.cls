public without sharing class sfcraft_LogConfig {
    private sfcraft_LogConfig__mdt config;

    private SObjectType sobjType;

    public sfcraft_LogConfig() {
        List<sfcraft_LogConfig__mdt> configs = [
            SELECT sfcraft_LogObject__c, sfcraft_DetailsField__c, sfcraft_MessageField__c, sfcraft_ScopeField__c,
                sfcraft_SeverityField__c
            FROM sfcraft_LogConfig__mdt
            WHERE sfcraft_IsActive__c = true
            LIMIT 1
        ];
        if (configs.isEmpty()) {
            throw new IllegalArgumentException(
                'No active log config found, please create sfcraft_LogConfig__mdt record'
            );
        }
        this.config = configs.get(0);
    }

    public String getDetailsFieldName() {
        return this.config.sfcraft_DetailsField__c;
    }

    public String getMessageFieldName() {
        return this.config.sfcraft_MessageField__c;
    }

    public String getScopeFieldName() {
        return this.config.sfcraft_ScopeField__c;
    }

    public String getSeverityFieldName() {
        return this.config.sfcraft_SeverityField__c;
    }

    public SObjectType getLogSObjectType() {
        if (null == this.sobjType) {
            String sobjTypeName = this.config.sfcraft_LogObject__c;
            this.sobjType = Schema.getGlobalDescribe().get(sobjTypeName);
        }
        return this.sobjType;
    }
}
