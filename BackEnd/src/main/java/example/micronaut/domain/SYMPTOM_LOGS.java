package example.micronaut.domain;
import java.sql.Timestamp;

import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class SYMPTOM_LOGS {
    @Id
    @GeneratedValue
    private int SYMPTOM_LOG_ID;
    private int SYMPTOM_ID;
    private int USER_ID;
    private int SEVERITY; 
    private Timestamp TIMESTAMP;
    private int CONDITION_ID;
    

    @Creator
    public SYMPTOM_LOGS(int SYMPTOM_LOG_ID, int SYMPTOM_ID, int USER_ID, int SEVERITY, Timestamp TIMESTAMP, int CONDITION_ID)
    {
        this.SYMPTOM_LOG_ID = SYMPTOM_LOG_ID;
        this.SYMPTOM_ID = SYMPTOM_ID;
        this.USER_ID = USER_ID;
        this.SEVERITY = SEVERITY;
        this.TIMESTAMP = TIMESTAMP;
        this.CONDITION_ID = CONDITION_ID;

    }

    public int getSYMPTOM_LOG_ID() {
        return SYMPTOM_LOG_ID;
    }

    public int getSYMPTOM_ID() {
        return SYMPTOM_ID;
    }
    public int getUSER_ID() {
        return USER_ID;
    }
    public int getSEVERITY() {
        return SEVERITY;
    }

    public Timestamp getTIMESTAMP() {
        return TIMESTAMP;
    }
    public int getCONDITION_ID() {
        return CONDITION_ID;
    }
    
}
