/* 
[JOIN 용어 정리]
  오라클       	  	                                SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인		                            내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인 		                        왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인   	                		    JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱		              			 교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.

-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!

/* 
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.   
*/

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 직원번호 , 직원명, 부서코드, 부서명을 조회하고자 할 때

SELECT EMP_ID,EMP_NAME, DEPT_CODE FROM EMPLOYEE;
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
-- 부서명은 DEPARTMENT 테이블에서 조회 가능

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE
/* INEER가 생략되어있음 */ JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);


-- 1. 내부 조인(INNER JOIN) ( == 등가 조인(EQUAL JOIN))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨. 
-- (== 일치하는 값이 없는 행은 조인에서 제외됨. ) -> DEPT_CODE가 NULL인 사람들은 조회에서 확인되지않음

-- 작성 방법 크게 ANSI구문과 오라클 구문 으로 나뉘고 
-- ANSI에서  USING과 ON을 쓰는 방법으로 나뉜다.

-- *ANSI 표준 구문
-- ANSI는 미국 국립 표준 협회를 뜻함, 미국의 산업표준을 제정하는 민간단체로 
-- 국제표준화기구 ISO에 가입되어있다.
-- ANSI에서 제정된 표준을 ANSI라고 하고 
-- 여기서 제정한 표준 중 가장 유명한 것이 ASCII코드이다.

-- *오라클 전용 구문
-- FROM절에 쉼표(,) 로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시한다




-- 1) 연결에 사용할 두 컬럼명이 다른 경우(ON)
-- 연결에 사용할 컬럼명이 다른 경우는 ON()을 사용한다

-- 직원번호 , 직원명, 부서코드, 부서명을 조회하고자 할 때
-- ANSI 기준
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 기준
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- DEPARTMENT테이블, LOCATION테이블을 참조하여
-- 부서명, 지역명 조회
/*
 * DEPARTMENT 테이블
 * DEPT_ID			부서코드
 * DEPT_TITLE		부서명
 * LOCATION_ID 		지역코드
 
 * LOCATION 테이블
 * LOCAL_CODE 		지역코드
 * LOCAL_NAME		지역명
 * NATIONAL_CODE	국가코드
 */
-- ANSI 기준
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 오라클 기준
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION 
WHERE LOCATION_ID = LOCAL_CODE;




-- 2) 연결에 사용할 두 컬럼명이 일치할 경우(USING)
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)을 사용한다.

-- EMPLOYEE테이블, JOB테이블을 참조하여 사번, 이름, 직급코드, 직급명 조회
-- ANSI기준
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 오라클 기준 -> 별칭 사용
-- 테이블별로 별칭을 등록할 수 있음.
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;



-- INNER JOIN(내부조인) 시 문제점!
--> 연결에 사용된 컬럼의 값이 일치하지 않으면 조회결과에 포함되지 않는다.

---------------------------------------------------------------------------------------------------------------


-- 2. 외부 조인(OUTER JOIN)

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
-->  *반드시 OUTER JOIN임을 명시해야 한다.

-- ANSI 표준

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의
-- 컬럼 수를 기준으로 JOIN
--> 왼편에 작성된 테이블의 모든 행이 결과에 포함되어야한다(JOIN이 안되는 행도 결과 포함)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT
ON (DEPT_CODE = DEPT_ID); -- 23행(하동운, 이오리 포함)


-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 컬럼수를 기준으로 JOIN
--> 오른편에 작성된 테이블의 모든 행이 결과에 포함되어야한다(JOIN이 안되는 행도 결과 포함)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT JOIN DEPARTMENT
ON (DEPT_CODE = DEPT_ID); -- 24행(마케팅부, 국내영업부, 해외영업3부 포함)


--3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);


-- 오라클
-- 1) LEFT [OUTER] JOIN 
-- 기준이 될 테이블의 반대쪽 테이블 컬럼에 (+)기호를 작성해야한다!
SELECT EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); --EMPLOYEE 기준 조회


-- 2) RIGHT [OUTER] JOIN
-- 기준이 될 테이블의 반대쪽 테이블 컬럼에 (+)기호를 작성해야한다!
SELECT EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID; --DEPARTMENT 기준 조회


--3) FULL [OUTER] JOIN --> 오라클은 FULL JOIN이 없음 안됨!
/*SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID; 
*/



---------------------------------------------------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN == CARTESIAN PRODUCT)
--  조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집합/ 모든 경우의 수)
--> JOIN 구문을 잘못 작성하는 경우 CROSS JOIN의 결과가 조회됨

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; -- 207행 == EMPLOYEE 23 * DEPARTMENT 9 

---------------------------------------------------------------------------------------------------------------

-- 4. 비등가 조인(NON EQUAL JOIN)

-- '='(등호)를 사용하지 않는 조인문
--  지정한 컬럼 값이 일치하는 경우가 아닌, "값의 범위에 포함되는 행"들을 연결하는 방식

SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

---------------------------------------------------------------------------------------------------------------

-- 5. 자체 조인(SELF JOIN)

-- 같은 테이블을 조인.
-- 자기 자신과 조인을 맺음
-- TIP! 같은 테이블 2개 있다고 생각하고 JOIN을 진행

-- 사번, 이름, 사수의 사번, 사수의 이름 조회

--ANSI 표준
SELECT E1.EMP_ID, E1.EMP_NAME, NVL(E1.MANAGER_ID, '없음') "사수의 사번", NVL( E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID);

--오라클
SELECT E1.EMP_ID, E1.EMP_NAME, NVL(E1.MANAGER_ID, '없음') "사수의 사번", NVL( E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+) ;

---------------------------------------------------------------------------------------------------------------

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요
--> 없을 경우 교차조인이 됨.

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
--JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB;


SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
--> 잘못 조인하면 CROSS JOIN 결과 조회됨


---------------------------------------------------------------------------------------------------------------

-- 7. 다중 조인
-- N개의 테이블을 조회할 때 사용  (순서 중요!)

-- 사원이름,   부서명,    지역명 	조회
-- EMPLOYEE, DEPARTMENT, LOCATION

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- JOIN은 위에서 아래로 차례대로 진행
--> 다중조인 시 앞에서 조인된 결과에 새로운 테이블 내용을 조인

SELECT * FROM EMPLOYEE
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- "LOCATION_ID": 부적합한 식별자
--> EMPLOYEE테이블에 LOCATION_ID 컬럼이 없어서 오류 발생
--> 해결방법 : DEPARTMENT와 LOCATION 조인 순서를 바꿔서
--				 EMPLOYEE와 DEPARTMENT 조인된 결과를 먼저 만들어
--				LOCATION_ID컬럼이 존재할 수 있도록 만든다.

SELECT * FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);


-- 오라클
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID -- EMPLOYEE+DEPARTMENT JOIN 
AND LOCATION_ID = LOCAL_CODE; -- +LOCATION JOIN



--[다중 조인 연습 문제]

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하세요

-- ANSI 버전
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E1
JOIN JOB J1 ON(E1.JOB_CODE = J1.JOB_CODE )
JOIN DEPARTMENT D1 ON(E1.DEPT_CODE = D1.DEPT_ID )
JOIN LOCATION L1 ON(D1.LOCATION_ID = L1.LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';

-- 풀이
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';


-- 오라클
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E1, JOB J1, DEPARTMENT, LOCATION
WHERE E1.JOB_CODE = J1.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '대리' 
AND LOCAL_NAME LIKE 'ASIA%';


---------------------------------------------------------------------------------------------------------------


-- [연습문제]

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 
-- 사원명, 주민번호, 부서명, 직급명을 조회하시오.

SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE EMP_NO LIKE '7%' 
AND SUBSTR(EMP_NO, 8, 1) = '2'
AND EMP_NAME LIKE '전%';


-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을 조회하시오.

SELECT EMP_NO, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE
-- JOIN JOB USING(JOB_CODE) -- NATURAL JOIN으로 사용해줘도됨
NATURAL JOIN JOB
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE EMP_NAME LIKE '%형%';


-- 3. 해외영업 1부, 2부에 근무하는 사원의 
-- 사원명, 직급명, 부서코드, 부서명을 조회하시오.

SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
-- WHERE DEPT_TITLE LIKE '%1부' OR DEPT_TITLE LIKE '%2부';
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부');


-- 4. 보너스포인트를 받는 직원들의 
-- 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
LEFT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;
-- LEFT JOIN을 사용하지않으면 하동운이 검색되지않음 -> DEPT_TITLE, LOCAL_NAME이 NULL이기 때문


-- 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회

SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
-- WHERE DEPT_CODE IS NOT NULL; 이너조인을 사용해서 NULL 값을 찾는 WHERE절은 없어도 됨


-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의
-- 사원명, 직급명, 급여, 연봉(보너스포함)을 조회하시오.
-- 연봉에 보너스포인트를 적용하시오.
-- SALARY * (1 + NVL(BONUS,0) ) * 12 연봉

SELECT EMP_NAME, JOB_NAME, SALARY, SALARY * (1 + NVL(BONUS,0) ) * 12 연봉
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE MIN_SAL < SALARY;


-- 7. 한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명, 부서명, 지역명, 국가명을 조회하시오.

SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
NATURAL JOIN NATIONAL
WHERE NATIONAL_CODE IN ('KO', 'JP');


-- 8. 같은 부서에 근무하는 직원들의
-- 사원명, 부서코드, 동료이름을 조회하시오.
-- SELF JOIN 사용

SELECT E1.EMP_NAME, E1.DEPT_CODE 부서코드, E2.EMP_NAME 동료이름
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME -- 동료를 찾아야하고 자기자신을 찾으면 안됨
ORDER BY 1;


-- 9. 보너스포인트가 없는 직원들 중에서 
-- 직급코드가 J4와 J7인 직원들의 
-- 사원명, 직급명, 급여를 조회하시오.
-- 단, JOIN, IN 사용할 것

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4', 'J7');
