package example.micronaut.domain;
import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class SYMPTOMS {
    @Id
    @GeneratedValue
    private int SYMPTOM_ID;
    private int CONDITION_ID;
    private String SYMPTOM;


    @Creator
    public SYMPTOMS(int SYMPTOM_ID, int CONDITION_ID, String SYMPTOM)
    {
        this.SYMPTOM_ID = SYMPTOM_ID;
        this.CONDITION_ID = CONDITION_ID;
        this.SYMPTOM = SYMPTOM;

    }

    public int getSYMPTOM_ID() {
        return SYMPTOM_ID;
    }
    public int getCONDITION_ID() { return CONDITION_ID; }
    public String getSYMPTOM() {
        return SYMPTOM;
    }

}
