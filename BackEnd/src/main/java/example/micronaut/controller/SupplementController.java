package example.micronaut.controller;

import java.util.List;
import java.util.ArrayList;

import example.micronaut.domain.SUPPLEMENTS;
import example.micronaut.repository.SupplementRepository;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.scheduling.TaskExecutors;
import io.micronaut.scheduling.annotation.ExecuteOn;

@Controller("/SUPPLEMENTS")
@ExecuteOn(TaskExecutors.IO)

class SupplementController {
    private final SupplementRepository supplementRepository;
    SupplementController (SupplementRepository supplementRepository)
    {
        this.supplementRepository = supplementRepository;
    }


    @Get("/")
    List<SUPPLEMENTS> all()
    {
        List<SUPPLEMENTS> allSupps = supplementRepository.findAll();
        List<String> names = new ArrayList<String>();
        List<SUPPLEMENTS> returnedList = new ArrayList<SUPPLEMENTS>();
        for(int i = 0; i < allSupps.size(); i++)
        {
            if(!names.contains(allSupps.get(i).getDESCRIPTION()))
            {
                returnedList.add(allSupps.get(i));
                names.add(allSupps.get(i).getDESCRIPTION());
            }
        }
        return returnedList;
    }


    SupplementRepository returnRepo()
    {return this.supplementRepository;}

}
