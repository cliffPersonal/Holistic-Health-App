package example.micronaut.domain;
import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class SUPPLEMENTS {
    @Id
    @GeneratedValue
    private int SUPPLEMENT_ID;
    private int SYMPTOM_ID;
    private String DESCRIPTION; 
    

    @Creator
    public SUPPLEMENTS(int SUPPLEMENT_ID, int SYMPTOM_ID, String DESCRIPTION)
    {
        this.SUPPLEMENT_ID = SUPPLEMENT_ID;
        this.SYMPTOM_ID = SYMPTOM_ID;
        this.DESCRIPTION = DESCRIPTION;

    }

    public int getSUPPLEMENT_ID() {
        return SUPPLEMENT_ID;
    }
    public int getSYMPTOM_ID() {
        return SYMPTOM_ID;
    }
    public String getDESCRIPTION() {
        return DESCRIPTION;
    }
    
}
