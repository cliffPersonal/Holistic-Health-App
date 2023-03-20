package example.micronaut.repository;
import java.util.List;

import example.micronaut.domain.SUPPLEMENTS;

import example.micronaut.domain.USER_CONDITIONS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface UserConditionRepository extends CrudRepository<USER_CONDITIONS,Long>{
    @Override
    List<USER_CONDITIONS> findAll();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?

    @Query("SELECT * FROM USER_CONDITIONS WHERE USER_ID LIKE :id")
    List<USER_CONDITIONS> findById(int id); //find by user id

}


