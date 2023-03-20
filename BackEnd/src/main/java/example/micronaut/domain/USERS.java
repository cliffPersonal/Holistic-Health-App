package example.micronaut.domain;
import io.micronaut.core.annotation.Creator;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

import java.sql.Date;

@MappedEntity
public class USERS {
    @Id
    @GeneratedValue
    private int USER_ID;
    private String EMAIL;
    private String PASSWORD;
    private String FIRSTNAME;
    private String LASTNAME;
    private Date BIRTHDATE;

    @Creator
    public USERS(int USER_ID, String EMAIL, String PASSWORD, String FIRSTNAME, String LASTNAME, Date BIRTHDATE)
    {
        this.USER_ID = USER_ID;
        this.EMAIL = EMAIL;
        this.PASSWORD = PASSWORD;
        this.FIRSTNAME = FIRSTNAME;
        this.LASTNAME = LASTNAME;
        this.BIRTHDATE = BIRTHDATE;
    }

    public int getUSER_ID() {
        return USER_ID;
    }
    public String getEMAIL() {
        return EMAIL;
    }
    public String getPASSWORD() {
        return PASSWORD;
    }
    public String getFIRSTNAME() {
        return FIRSTNAME;
    }
    public String getLASTNAME() {
        return LASTNAME;
    }
    public Date getBIRTHDATE() {
        return BIRTHDATE;
    }
}
