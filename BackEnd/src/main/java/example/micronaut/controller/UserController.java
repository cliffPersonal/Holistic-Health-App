package example.micronaut.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.validation.constraints.NotBlank;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import example.micronaut.domain.SUPPLEMENT_LOGS;
import example.micronaut.domain.SYMPTOM_LOGS;
import example.micronaut.domain.USERS;
import example.micronaut.repository.SupplementLogRepository;
import example.micronaut.repository.SupplementRepository;
import example.micronaut.repository.SymptomLogRepository;
import example.micronaut.repository.SymptomRepository;
import example.micronaut.repository.UserRepository;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import io.micronaut.scheduling.TaskExecutors;
import io.micronaut.scheduling.annotation.ExecuteOn;
import net.minidev.json.JSONObject;


@Controller("/USERS")
@ExecuteOn(TaskExecutors.IO)

class UserController {
    private final UserRepository userRepository;
    private final SymptomRepository symptomRepository;
    private final SupplementRepository supplementRepository;
    private final SupplementLogRepository supplementLogRepository;
    private final SymptomLogRepository symptomLogRepository;
    UserController (UserRepository userRepository, SupplementLogRepository supplementLogRepository, SymptomLogRepository symptomLogRepository, SymptomRepository symptomRepository, SupplementRepository supplementRepository)
    {
        this.userRepository = userRepository;
        this.symptomRepository = symptomRepository;
        this.supplementRepository = supplementRepository;
        this.supplementLogRepository = supplementLogRepository;
        this.symptomLogRepository = symptomLogRepository;
    }


    @Get("/")
    List<USERS> all()
    {
        return userRepository.findAll();
    }

    @Get("/ID/{USER_ID}")
    Optional<USERS> byName(@NotBlank int USER_ID)
    {
        return userRepository.findById(USER_ID);
    }

    @Get("/EMAIL/{EMAIL}")
    Optional<USERS> byEMAIL(@NotBlank String EMAIL)
    {
        return userRepository.findByEmail(EMAIL);
    }

    @Post("/UPDATE")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateUser(@Body USERS user)
    {
        //System.out.println(user.getBIRTHDATE() + " is the birthdate");
        userRepository.updateUserInfo(user.getUSER_ID(),user.getEMAIL(),user.getPASSWORD(),user.getFIRSTNAME(),user.getLASTNAME(),user.getBIRTHDATE());
        return Response.status(201).entity("Update success.").build();
    }
//    @Post("/login")
//    @Consumes("application/json")
//    HttpResponse<List<USERS>> login(HttpRequest<?> request)
//    {
//        //String name = request.getParameters();
//        //return userRepository.findAll();
//        //return userRepository.findAll();
//    }

//    @Get("/verify/{EMAIL}/{PASSWORD}")
//    Optional<USERS> login(@NotBlank String EMAIL, @NotBlank String PASSWORD)
//    {
//        USERS user = userRepository.findByEmail(EMAIL);
//        if (user == null || user.getPASSWORD() != PASSWORD)
//        {
//            return null; //error code?
//        }
//        return user;
//    }

//    @Get("/login")
//    public HttpResponse<USERS> login(HttpRequest<?> request) {
//        String name = request.getParameters()
//    }


    @Post("/returnLogs")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response returnLogs(int user_id) {
        

        List<SUPPLEMENT_LOGS> suppLogs = supplementLogRepository.findByUserId(user_id);
        List<SYMPTOM_LOGS> sympLogs = symptomLogRepository.findByUserId(user_id);


        JSONObject allLogs = new JSONObject();

        
        //find all logs of the same day and put them together
        for(int i = 0; i < sympLogs.size(); i++)
        {
            List<JSONObject> currentDayJSONs = new ArrayList<JSONObject>();
            LocalDate symptomDay = sympLogs.get(i).getTIMESTAMP().toLocalDateTime().toLocalDate();
            JSONObject dateJSON = new JSONObject();
            JSONObject temp = new JSONObject();
            dateJSON.put("Date", symptomDay.toString());
            currentDayJSONs.add(dateJSON);
            temp.put("SymptomLog", sympLogs.get(i));
            temp.put("SymptomInfo", symptomRepository.findById(sympLogs.get(i).getSYMPTOM_ID()));
            currentDayJSONs.add(temp);
            sympLogs.remove(i);
            for(int j = 0; j < sympLogs.size(); j++) //find all same day sypmtomlogs
            {
                LocalDate dateToCompare = sympLogs.get(j).getTIMESTAMP().toLocalDateTime().toLocalDate();
                if(symptomDay.equals(dateToCompare))
                {
                    JSONObject sameDayLog = new JSONObject();
                    sameDayLog.put("SymptomLogs", sympLogs.get(j));
                    sameDayLog.put("SymptomInfo", symptomRepository.findById(sympLogs.get(j).getSYMPTOM_ID()));
                    currentDayJSONs.add(sameDayLog);
                    sympLogs.remove(j);
                }
            }

            for(int q = 0; q < suppLogs.size(); q++) 
            {
                
                LocalDate dateToCompare = suppLogs.get(q).getTIMESTAMP().toLocalDateTime().toLocalDate();
                if(symptomDay.equals(dateToCompare))
                {
                    JSONObject sameDayLog = new JSONObject();
                    sameDayLog.put("SupplementLogs", suppLogs.get(q));
                    sameDayLog.put("SupplementInfo", supplementRepository.findById(suppLogs.get(q).getSUPPLEMENT_ID()));
                    currentDayJSONs.add(sameDayLog);
                    suppLogs.remove(q);
                    
                }

            }

            
            allLogs.put("DayLogs" + i, currentDayJSONs);
            

        }

        

        //CURRENTLY DOES NOT WORK FOR SUPPLEMENT LOGS THAT ARE LOGGED WITHOUT ANY SYMPTOM LOGS FOR THE SAME DAY
        String jsonString = allLogs.toString();
        return Response.status(201).entity(jsonString).build();
    }


    UserRepository returnRepo()
    {return this.userRepository;}

}
