package example.micronaut.repository;
import java.util.List;

import example.micronaut.domain.SYMPTOMS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface SymptomRepository extends CrudRepository<SYMPTOMS,Long>{
    @Override
    List<SYMPTOMS> findAll();

    @Query("SELECT * FROM SYMPTOMS")
    List<SYMPTOMS> getSymps();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?
    @Query("SELECT * FROM SYMPTOMS WHERE SYMPTOM_ID LIKE :sympID")
    SYMPTOMS findById(int sympID);

    @Query("SELECT * FROM SYMPTOMS WHERE CONDITION_ID LIKE :conditionid")
    List<SYMPTOMS> findByCondition(int conditionid);

    @Query("SELECT * FROM SYMPTOMS WHERE SYMPTOM LIKE :name")
    SYMPTOMS findByName(String name);
    


}
