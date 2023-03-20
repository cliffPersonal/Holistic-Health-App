package example.micronaut.repository;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

import example.micronaut.domain.USERS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface UserRepository extends CrudRepository<USERS,Long>{
    @Override
    List<USERS> findAll();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?
    Optional<USERS> findById(int USER_ID);

    @Query("SELECT * FROM USERS WHERE EMAIL LIKE :em")
    Optional<USERS> findByEmail(String em);

    @Query("SELECT * FROM USERS WHERE EMAIL LIKE :em")
    USERS returnUser(String em);

    @Query("UPDATE USERS SET USERS.EMAIL = :em, USERS.PASSWORD = :pass, USERS.FIRSTNAME = :firstnam, USERS.LASTNAME = :lastnam, USERS.BIRTHDATE = :bday WHERE USER_ID = :id")
    void updateUserInfo(int id, String em, String pass, String firstnam, String lastnam, Date bday);

}
