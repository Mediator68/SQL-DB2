CREATE or REPLACE FUNCTION EURO4.info_cde( 
  pNDOC VARCHAR(8), pState VARCHAR(50) 

) 
RETURNS TABLE (Num_Doc CHAR(8), Date_Cde INTEGER, Num_Client CHAR(8), Code_Solde char(1), Code_Article char(13), Qte_Cde decimal(11,3) ) 
LANGUAGE SQL 
NOT FENCED 
MODIFIES SQL DATA   
BEGIN 
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
      BEGIN   
        DECLARE ERROR_HIT INTEGER; 
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
           SET ERROR_HIT = 1; 
        CREATE TABLE QTEMP/info_cde (Num_Doc CHAR(8), Date_Cde INTEGER, Num_Client CHAR(8), Code_Solde char(1), Code_Article char(13), Qte_Cde decimal(11,3) ); 
      END; 
delete from QTEMP/info_cde; 
IF pState='ACTIVE'THEN  
  INSERT INTO QTEMP/info_cde (Num_Doc, Date_Cde, Num_Client, Code_Solde, Code_Article, Qte_Cde) SELECT A.NDOC, A.DTCO, A.NCLI,  A.CDSO, B.NART, B.QCDE FROM CDEENT A  
LEFT OUTER JOIN LIGNES B ON A.NDOC=B.NDOC  
LEFT OUTER JOIN VALDOC C ON C.TPIE='CO' and C.NPIE=A.NDOC  
where A.NDOC=pNDOC and B.CDSO<>'8' ; 
ELSEIF pState='INACTIVE' THEN 
  INSERT INTO QTEMP/info_cde (Num_Doc, Date_Cde, Num_Client, Code_Solde, Code_Article, Qte_Cde) SELECT A.NDOC, A.DTCO, A.NCLI,  A.CDSO, B.NART, B.QCDE FROM CDEENT A  
LEFT OUTER JOIN LIGNES B ON A.NDOC=B.NDOC  
LEFT OUTER JOIN VALDOC C ON C.TPIE='CO' and C.NPIE=A.NDOC  
where A.NDOC=pNDOC and B.CDSO='8' ; 
ELSE 
INSERT INTO QTEMP/info_cde (Num_Doc, Date_Cde, Num_Client, Code_Solde, Code_Article, Qte_Cde) SELECT A.NDOC, A.DTCO, A.NCLI,  A.CDSO, B.NART, B.QCDE FROM CDEENT A  
LEFT OUTER JOIN LIGNES B ON A.NDOC=B.NDOC  
LEFT OUTER JOIN VALDOC C ON C.TPIE='CO' and C.NPIE=A.NDOC  
where A.NDOC=pNDOC ; 
END IF; 
RETURN select * from QTEMP/info_cde; 
END 

 

Exemple d'appel 

select * from table(info_cde(pNDOC => '13002083', pState => 'ACTIVE')) 