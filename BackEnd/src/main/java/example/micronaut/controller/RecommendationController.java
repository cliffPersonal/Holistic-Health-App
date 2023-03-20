package example.micronaut.controller;

import java.time.LocalDate;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import example.micronaut.domain.*;
import example.micronaut.repository.*;
import io.micronaut.http.annotation.*;
import io.micronaut.http.annotation.Controller;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;


@Controller("/")
public class RecommendationController {
    private final UserRepository userRepository;
    private final SymptomLogRepository symptomLogRepository;
    private final SupplementLogRepository supplementLogRepository;
    private final SupplementRepository supplementRepository;
    private final SymptomRepository symptomRepository;
    RecommendationController(UserRepository userRepository, SupplementRepository supplementRepository,SymptomLogRepository symptomLogRepository, SupplementLogRepository supplementLogRepository, SymptomRepository symptomRepository){
        this.userRepository = userRepository;
        this.symptomLogRepository = symptomLogRepository;
        this.supplementLogRepository = supplementLogRepository;
        this.supplementRepository = supplementRepository;
        this.symptomRepository = symptomRepository;
    }


    public boolean inSameCalendarWeek(LocalDate firstDate, LocalDate secondDate) {
        // get a reference to the system of calendar weeks in your defaul locale
        WeekFields weekFields = WeekFields.of(Locale.getDefault());
        // find out the calendar week for each of the dates
        int firstDatesCalendarWeek = firstDate.get(weekFields.weekOfWeekBasedYear());
        int secondDatesCalendarWeek = secondDate.get(weekFields.weekOfWeekBasedYear());
        /*
         * find out the week based year, too,
         * two dates might be both in a calendar week number 1 for example,
         * but in different years
         */
        int firstWeekBasedYear = firstDate.get(weekFields.weekBasedYear());
        int secondWeekBasedYear = secondDate.get(weekFields.weekBasedYear());
        // return if they are equal or not
        return firstDatesCalendarWeek == secondDatesCalendarWeek
                && firstWeekBasedYear == secondWeekBasedYear;
    }



    @Post("RECOMMENDATIONS")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response generateRecommendations(@Body USERS user) //added parameter like is passed in login
    {


        //int MAX_RECS = 1000; //maximum number of recommendations. For flexibility, can set to (total number of symptom logs / 3).
        List<SUPPLEMENTS> potentialRecommendations = new ArrayList<SUPPLEMENTS>();
        List<SUPPLEMENTS> recommendedSupplements = new ArrayList<SUPPLEMENTS>(); //returned list of supplements to recommend
        List<SUPPLEMENT_LOGS> allSupplementLogs = supplementLogRepository.getLogs(); //NOT SORTED BY TIMESTAMP
        System.out.println("SUPPLEMENT LOG IS OKAY");
        List<SYMPTOM_LOGS> allDecreasingSymptoms = new ArrayList<SYMPTOM_LOGS>();
        List<SYMPTOM_LOGS> sameUserSymptomLogs = new ArrayList<SYMPTOM_LOGS>();
        //int[] added = new int[MAX_RECS];

        for(int i = 0; i < allSupplementLogs.size(); i++) //Start by looking through every supplement log
        {
            SUPPLEMENT_LOGS curSupLog = allSupplementLogs.get(i); //The current supplement log we are working with
            sameUserSymptomLogs = symptomLogRepository.findByUserId(curSupLog.getUSER_ID()); //all symptoms logs belonging to the user of the current supplement log
            System.out.println("SYMPTOM LOG IS OKAY");
            if(true)
            {
                //return sameUserSymptomLogs;
            }
            List<SUPPLEMENT_LOGS> sameUserSupplementLogs = supplementLogRepository.findByUserId(curSupLog.getUSER_ID()); //all supplement logs of this user
            List<Integer> userSupplementIDs = new ArrayList<Integer>(); //IDs of all supplements that the current user is taking
            List<Integer> userSymptomIDs = new ArrayList<Integer>(); //IDs of all symptoms that the current user is experiencing

            List<SYMPTOM_LOGS> decreasingSymptoms = new ArrayList<SYMPTOM_LOGS>();





            for(int j = 0; j < sameUserSymptomLogs.size(); j++)
            {
                int curSympID = sameUserSymptomLogs.get(j).getSYMPTOM_ID();

                if(!userSymptomIDs.contains(curSympID)) //Check the current ID has not yet been processed
                {
                    userSymptomIDs.add(curSympID);

                    boolean decreasing = false;
                    int lastSeverity = 0;
                    for(int p = 0; p < sameUserSymptomLogs.size(); p++) //loop and find whether severity of a symptom is decreasing over a 3 log period.
                    {
                        if(sameUserSymptomLogs.get(p).getSYMPTOM_ID() == curSympID)
                        {
                            SYMPTOM_LOGS curLog = sameUserSymptomLogs.get(p);

                            if(decreasing && curLog.getSEVERITY() < lastSeverity)
                            {
                                decreasingSymptoms.add(curLog);
                                allDecreasingSymptoms.add(curLog);

                            }

                            if(curLog.getSEVERITY() < lastSeverity)
                            {
                                decreasing = true;
                                //List<SYMPTOM_LOGS> ret = new ArrayList<SYMPTOM_LOGS>();
                                //ret.add(sameUserSymptomLogs.get(p-1));
                                //ret.add(sameUserSymptomLogs.get(p));

                                //return ret;
                            }else{
                                decreasing = false;
                            }

                            lastSeverity = curLog.getSEVERITY();

                            sameUserSymptomLogs.remove(sameUserSymptomLogs.get(p));
                            p--;

                        }
                    }
                }
            }





            Map<Integer, List<SUPPLEMENT_LOGS>> supplementsByType = new HashMap<>();
            for(int j = 0; j < sameUserSupplementLogs.size(); j++)
            {
                //LOOK THROUGH SUPPLEMENT LOGS WITH TIMESTAMPS A FEW (days/weeks?) BEFORE THE LOGS IN "decreasingSymptoms"
                //IF A SUPPLEMENT WAS TAKEN (consistently?) AROUND THAT PERIOD ADD IT TO "potentialRecommendations"
                int curSupID = sameUserSupplementLogs.get(j).getSUPPLEMENT_ID();
                if(!userSupplementIDs.contains(curSupID)) //Check the current supplement ID has not yet been processed
                {
                    userSupplementIDs.add(curSupID);
                    //add to map since we haven't seen this id yet
                    List<SUPPLEMENT_LOGS> tempList = new ArrayList<SUPPLEMENT_LOGS>();
                    tempList.add(sameUserSupplementLogs.get(j));
                    supplementsByType.put(curSupID, tempList);
                }
                else{
                    //add to the list inside map
                    List<SUPPLEMENT_LOGS> tempList = supplementsByType.get(curSupID); //get list
                    tempList.add(sameUserSupplementLogs.get(j)); //add this log to list
                    supplementsByType.replace(curSupID, tempList); //add new list back to map at this id
                }
            }
            //iterate over the map


            for(int k = 0; k < decreasingSymptoms.size(); k++)
            {
                Iterator mapIt = supplementsByType.entrySet().iterator();

                while(mapIt.hasNext()){
                    int cnt = 0;
                    Map.Entry<Integer, List<SUPPLEMENT_LOGS>> mapElement = (Map.Entry)mapIt.next();
                    List<SUPPLEMENT_LOGS> tempList = mapElement.getValue();
                    for(int q=0; q<tempList.size(); q++){
                        //Timestamp curTime = Timestamp.from(Instant.now());
                        //Timestamp ts = curTime;

                        //if(q > 0)
                        //{
                        LocalDate d1 = decreasingSymptoms.get(k).getTIMESTAMP().toLocalDateTime().toLocalDate();
                        LocalDate d2 = tempList.get(q).getTIMESTAMP().toLocalDateTime().toLocalDate();
                        if(inSameCalendarWeek(d1, d2)){ //if curtime - timestamp
                            //within a week

                            int id = tempList.get(q).getSUPPLEMENT_ID();
                            SUPPLEMENTS supp = supplementRepository.findById(id);
                            potentialRecommendations.add(supp);



                        }
                        //}
                    }
                }

            }

        }

        List<Integer> recIDs = new ArrayList<Integer>();
        for(int i = 0; i < potentialRecommendations.size(); i++)
        {

            SUPPLEMENTS curRec = potentialRecommendations.get(i);
            if(!(recIDs.contains(curRec.getSUPPLEMENT_ID()))) //if current suppID has not been looked at
            {
                recIDs.add(curRec.getSUPPLEMENT_ID());
                recommendedSupplements.add(curRec);

            }

        }

        //edge case - first week
        //make a list of all supplements with curSupID
        //consistently = taken 4 times in the last 7 days (subject to change)

        //FOR NOW, "recommendedSupplements" CAN JUST BE SET TO "potentialRecommendations" BUT AT SOME POINT WE NEED TO
        //CHECK THE PERCENTAGE OF USERS WHO HAD A SYMPTOM IN "decreasingSymptoms" WHILE TAKING THE SAME SUPPLEMENT


        //RACHEL/NIRV
        //we want to take in a user like we do for login and then check what symptoms they have and what supplements they are taking.
        //If they have a symptom and are not taking a supplement that is recommended for it, we want to add that to a list.
        //Then, we just need to return the list of recommendation for supplements they are not yet taking that help symptoms that they have.
        //shouldn't be too bad lmk if you need any clarification

        //get user's symptom and supplement logs
        List<SYMPTOM_LOGS> thisUserSymptomLogs = new ArrayList<SYMPTOM_LOGS>();
        thisUserSymptomLogs = symptomLogRepository.findByUserId(user.getUSER_ID());
        List<SUPPLEMENT_LOGS> thisUserSupplementLogs = new ArrayList<SUPPLEMENT_LOGS>();
        thisUserSupplementLogs = supplementLogRepository.findByUserId(user.getUSER_ID());
        //store just symptom and supplement IDs
        List<Integer> userSymptoms = new ArrayList<Integer>();
        List<Integer> userSupplements = new ArrayList<Integer>();
        //get all the unique symptom ids
        for(int i = 0; i < thisUserSymptomLogs.size(); i++) {
            int curSympID = thisUserSymptomLogs.get(i).getSYMPTOM_ID();

            if (!userSymptoms.contains(curSympID)) //Check the current ID has not yet been processed
            {
                userSymptoms.add(curSympID);
            }
        }
        //get all the unique supplement ids
        for(int i = 0; i < thisUserSupplementLogs.size(); i++) {
            int curSuppID = thisUserSupplementLogs.get(i).getSUPPLEMENT_ID();

            if (!userSupplements.contains(curSuppID)) //Check the current ID has not yet been processed
            {
                userSupplements.add(curSuppID);
            }
        }
        /*
        for each symptom:
            for each supplement:
                if supplement is for current symptom AND user is not taking it:
                    add to recommended supplements
         */
        SupplementRepository suppRepo;
        List<SUPPLEMENTS> allSups = new ArrayList<SUPPLEMENTS>();
        allSups = supplementRepository.getSupps();
        for(int i = 0; i < userSymptoms.size(); i++){
            for(int j = 0; j < allSups.size(); j++){
                if(allSups.get(j).getSYMPTOM_ID() == userSymptoms.get(i) && !userSupplements.contains(allSups.get(j))){
                    recommendedSupplements.add(allSups.get(j));
                }
            }
        }

        JSONObject jsonArrayObject = new JSONObject();
        JSONArray recsJsonArray = new JSONArray();

        for(int i = 0; i < recommendedSupplements.size(); i++) {

            String jsonString;
            JSONObject j= new JSONObject();
//            j.put("SUPPLEMENT_ID", recommendedSupplements.get(i).getSUPPLEMENT_ID());
//            j.put("SYMPTOM_ID", recommendedSupplements.get(i).getSYMPTOM_ID());

            SYMPTOMS symp = symptomRepository.findById(recommendedSupplements.get(i).getSYMPTOM_ID());
            j.put("SYMPTOM", symp.getSYMPTOM());
            j.put("SUPPLEMENT", recommendedSupplements.get(i).getDESCRIPTION());
            jsonString = j.toString();

            recsJsonArray.add(jsonString);

        }

        jsonArrayObject.put("result", recsJsonArray);

        //return recommendedSupplements;
        //return potentialRecommendations;
        return Response.status(201).entity(jsonArrayObject).build();
    }


}
