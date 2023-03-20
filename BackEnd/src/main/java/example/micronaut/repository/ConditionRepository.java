package example.micronaut.repository;
import java.util.List;
import java.util.Optional;

import example.micronaut.domain.CONDITIONS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface ConditionRepository extends CrudRepository<CONDITIONS,Long>{
    @Override
    List<CONDITIONS> findAll();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?
    //this will return back a CONDITIONS given an id
    @Query("SELECT * FROM CONDITIONS WHERE CONDITION_ID LIKE :id")
    CONDITIONS findById(int id);

    @Query("SELECT * FROM CONDITIONS WHERE CONDITION_NAME LIKE :name")
    CONDITIONS findByName(String name);
}
