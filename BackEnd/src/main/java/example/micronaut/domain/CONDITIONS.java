package example.micronaut.domain;
import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class CONDITIONS {
    @Id
    @GeneratedValue
    private int CONDITION_ID;
    private String CONDITION_NAME; 
    

    @Creator
    public CONDITIONS(int CONDITION_ID, String CONDITION_NAME)
    {
        this.CONDITION_ID = CONDITION_ID;
        this.CONDITION_NAME = CONDITION_NAME;

    }

    public int getCONDITION_ID() {
        return CONDITION_ID;
    }

    public String getCONDITION_NAME() {
        return CONDITION_NAME;
    }

    
}
