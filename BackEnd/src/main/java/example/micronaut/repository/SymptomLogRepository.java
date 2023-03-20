package example.micronaut.repository;
import java.util.List;

import example.micronaut.domain.SYMPTOM_LOGS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface SymptomLogRepository extends CrudRepository<SYMPTOM_LOGS,Long>{
    @Override
    List<SYMPTOM_LOGS> findAll();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?
    @Query("SELECT * FROM SYMPTOM_LOGS WHERE USER_ID LIKE :uID ORDER BY TIMESTAMP")
    List<SYMPTOM_LOGS> findByUserId(int uID);

}