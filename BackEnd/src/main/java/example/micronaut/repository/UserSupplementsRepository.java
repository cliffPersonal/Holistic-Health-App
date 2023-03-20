package example.micronaut.repository;
import java.util.List;

import example.micronaut.domain.SUPPLEMENTS;

import example.micronaut.domain.USER_SUPPLEMENTS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface UserSupplementsRepository extends CrudRepository<USER_SUPPLEMENTS,Long>{
    @Override
    List<USER_SUPPLEMENTS> findAll();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?

    @Query("SELECT * FROM USER_SUPPLEMENTS WHERE USER_ID LIKE :id")
    List<USER_SUPPLEMENTS> findById(int id); //find by user id

}


