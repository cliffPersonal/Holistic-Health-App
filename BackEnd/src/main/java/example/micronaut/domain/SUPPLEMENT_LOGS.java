package example.micronaut.domain;
import java.sql.Timestamp;

import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class SUPPLEMENT_LOGS {
    @Id
    @GeneratedValue
    private int SUPPLEMENT_LOG_ID;
    private int SUPPLEMENT_ID;
    private int USER_ID;
    private int DOSAGE; 
    private String DOSAGE_UNIT;
    private Timestamp TIMESTAMP;
    

    @Creator
    public SUPPLEMENT_LOGS(int SUPPLEMENT_LOG_ID, int SUPPLEMENT_ID, int USER_ID, int DOSAGE, String DOSAGE_UNIT, Timestamp TIMESTAMP)
    {
        this.SUPPLEMENT_LOG_ID = SUPPLEMENT_LOG_ID;
        this.SUPPLEMENT_ID = SUPPLEMENT_ID;
        this.USER_ID = USER_ID;
        this.DOSAGE = DOSAGE;
        this.DOSAGE_UNIT = DOSAGE_UNIT;
        this.TIMESTAMP = TIMESTAMP;

    }

    public int getSUPPLEMENT_LOG_ID() {
        return SUPPLEMENT_LOG_ID;
    }

    public int getSUPPLEMENT_ID() {
        return SUPPLEMENT_ID;
    }
    public int getUSER_ID() {
        return USER_ID;
    }
    public int getDOSAGE() {
        return DOSAGE;
    }
    public String getDOSAGE_UNIT() {
        return DOSAGE_UNIT;
    }
    public Timestamp getTIMESTAMP() {
        return TIMESTAMP;
    }
    
}
