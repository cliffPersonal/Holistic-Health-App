package example.micronaut.repository;
import java.util.List;

import example.micronaut.domain.SUPPLEMENTS;
import io.micronaut.data.annotation.Query;
import io.micronaut.data.jdbc.annotation.JdbcRepository;
import io.micronaut.data.model.query.builder.sql.Dialect;
import io.micronaut.data.repository.CrudRepository;

@JdbcRepository(dialect = Dialect.ORACLE)
public interface SupplementRepository extends CrudRepository<SUPPLEMENTS,Long>{
    @Override
    List<SUPPLEMENTS> findAll();

    @Query("SELECT * FROM SUPPLEMENTS")
    List<SUPPLEMENTS> getSupps();

    // This method will compute at compilation time a query such as
    // SELECT ID, NAME, AGE FROM OWNER WHERE NAME = ?
    @Query("SELECT * FROM SUPPLEMENTS WHERE SUPPLEMENT_ID LIKE :suppID")
    SUPPLEMENTS findById(int suppID);

    @Query("SELECT * FROM SUPPLEMENTS WHERE DESCRIPTION LIKE :name")
    SUPPLEMENTS findByName(String name);


}
