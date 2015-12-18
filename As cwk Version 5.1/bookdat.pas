UNIT BOOKDAT;

INTERFACE

TYPE
       BookingInfo=Record
                         BookingNo          :STRING;
                         Surname            :STRING[15];
                         Forename           :STRING[30];
                         Gender             :CHAR;
                         PhoneNo            :STRING[15];
                         HouseNoOrTitle     :STRING[15];
                         Street             :STRING[15];
                         CityOrTown         :STRING[15];
                         County             :STRING[15];
                         PostCode           :STRING[7];
                         Origin             :STRING[20];
                         Destination        :STRING[20];
                         DayTravel          :CHAR;
                         HoursTravelling    :LONGINT;
                         Mileage            :LONGINT;
                         WaitingTime        :LONGINT;
                         NoOfNights         :LONGINT;
                         MilesCost          :REAL;
                         HoursCost          :REAL;
                         WaitingCost        :REAL;
                         TotalCost          :REAL;
                         OvernightCharge    :REAL;
                         Paid               :CHAR;
                       END;


IMPLEMENTATION
END.
