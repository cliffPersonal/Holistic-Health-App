package example.micronaut;

import example.micronaut.domain.USERS;
import example.micronaut.repository.UserRepository;
import io.micronaut.context.event.StartupEvent;
import io.micronaut.runtime.Micronaut;
import io.micronaut.runtime.event.annotation.EventListener;

import jakarta.inject.Singleton;
import javax.transaction.Transactional;
import java.sql.Date;
import java.util.Arrays;
@Singleton
public class Application {
    public static UserRepository userRepository;
    public Application(UserRepository userRepository)
    {
        this.userRepository = userRepository;
    }

    public static void main(String[] args) {
        Micronaut.run(Application.class, args);
    }

    @EventListener
    @Transactional
    void init(StartupEvent event){


        //String tempEmail = "cere@sc.edu";//for Nirvaan Reddy in the DB
        //Optional<USERS> user = userRepository.findByEmail(tempEmail);
        /*
        userRepository.deleteAll();
        USERS JudySong = new USERS(0,"cere@sc.edu", "myss", "Nirvaan", "Reddy", Date.valueOf("2030-03-03"));
        //userRepository.saveAll(Arrays.asList(JudySong));
        USERS RachelLeipold = new USERS(0,"rachel@sc.edu", "myss1", "Rachel", "Leipold", Date.valueOf("2030-03-03"));
        userRepository.saveAll(Arrays.asList(JudySong, RachelLeipold));
        */


    }

}
