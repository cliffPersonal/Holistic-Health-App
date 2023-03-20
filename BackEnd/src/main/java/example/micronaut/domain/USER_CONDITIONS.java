package example.micronaut.domain;
import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class USER_CONDITIONS {
    @Id
    @GeneratedValue
    private int USER_CONDITION_ID;
    private int USER_ID;
    private int CONDITION_ID;


    @Creator
    public USER_CONDITIONS(int USER_CONDITION_ID, int USER_ID, int CONDITION_ID)
    {
        this.USER_CONDITION_ID = USER_CONDITION_ID;
        this.CONDITION_ID = CONDITION_ID;
        this.USER_ID = USER_ID;

    }

    public int getUSER_CONDITION_ID() {return USER_CONDITION_ID;}

    public int getCONDITION_ID() {return CONDITION_ID;}

    public int getUSER_ID() {return USER_ID;}

}