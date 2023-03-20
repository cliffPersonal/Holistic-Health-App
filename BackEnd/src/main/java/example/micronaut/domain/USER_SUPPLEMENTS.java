package example.micronaut.domain;
import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

@MappedEntity
public class USER_SUPPLEMENTS {
    @Id
    @GeneratedValue
    private int USER_SUPPLEMENT_ID;
    private int USER_ID;
    private int SUPPLEMENT_ID;


    @Creator
    public USER_SUPPLEMENTS(int USER_SUPPLEMENT_ID, int USER_ID, int SUPPLEMENT_ID)
    {
        this.USER_SUPPLEMENT_ID = USER_SUPPLEMENT_ID;
        this.SUPPLEMENT_ID = SUPPLEMENT_ID;
        this.USER_ID = USER_ID;

    }

    public int getUSER_SUPPLEMENT_ID() {return USER_SUPPLEMENT_ID;}

    public int getSUPPLEMENT_ID() {return SUPPLEMENT_ID;}

    public int getUSER_ID() {return USER_ID;}

}