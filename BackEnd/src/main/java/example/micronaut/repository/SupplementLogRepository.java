package example.micronaut.repository;
import java.util.List;

import example.micronaut.domain.SUPPLEMENT_LOGS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface SupplementLogRepository extends CrudRepository<SUPPLEMENT_LOGS,Long>{
    @Override
    List<SUPPLEMENT_LOGS> findAll();

    @Query("SELECT * FROM SUPPLEMENT_LOGS")
    List<SUPPLEMENT_LOGS> getLogs();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?
    @Query("SELECT * FROM SUPPLEMENT_LOGS WHERE USER_ID LIKE :uID ORDER BY TIMESTAMP")
    List<SUPPLEMENT_LOGS> findByUserId(int uID);

}