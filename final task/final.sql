use MOVIES_W3;

SELECT * FROM actor;
SELECT * FROM director;
SELECT * FROM genres;
SELECT * FROM movie;
SELECT * FROM movie_cast;
SELECT * FROM movie_direction;
SELECT * FROM rating;
SELECT * FROM reviewer;


--1. Write a SQL query to find the name and year of the movies. Return movie title, movie release year.
SELECT mov_title, mov_year FROM movie;

--2. write a SQL query to find when the movie ‘American Beauty’ released. Return movie release year.
SELECT mov_year FROM movie 
WHERE mov_title = 'American Beauty';

--3. write a SQL query to find the movie, which was made in the year 1999. Return movie title.
SELECT mov_title FROM movie 
WHERE mov_year = 1999;

--4. write a SQL query to find those movies, which was made before 1998. Return movie title.
SELECT mov_title FROM movie 
WHERE mov_year < 1999;

--5. write a SQL query to find the name of all reviewers and movies together in a single list.
SELECT mov_title FROM movie 
UNION 
SELECT rev_name FROM reviewer;

--6. write a SQL query to find all reviewers who have rated 7 or more stars to their rating. Return reviewer name.
SELECT rev_name FROM reviewer INNER JOIN rating 
ON reviewer.rev_id = rating.rev_id 
WHERE rating.rev_stars >= 7;

--7.write a SQL query to find the movies without any rating. Return movie title.
SELECT movie.mov_title FROM movie INNER JOIN rating 
ON movie.mov_id = rating.mov_id
WHERE rating.num_o_ratings IS NULL;

--8. write a SQL query to find the movies with ID 905 or 907 or 917. Return movie title.
SELECT mov_title FROM movie 
WHERE mov_id IN (905, 907, 917);

--9. write a SQL query to find those movie titles, which include the words 'Boogie Nights'. Sort the result-set in ascending order by movie year. Return movie ID, movie title and movie release year.
SELECT mov_id, mov_title, mov_year FROM movie 
WHERE mov_title LIKE '%Boogie Nights%' 
ORDER BY mov_year;

--10. write a SQL query to find those actors whose first name is 'Woody' and the last name is 'Allen'. Return actor ID
SELECT act_fname, act_lname FROM actor 
WHERE act_fname = 'Woody'
AND 
act_lname = 'Allen';


-- Subqueries

--1. Find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.
SELECT * FROM actor 
WHERE act_id = (SELECT act_id FROM movie_cast 
WHERE mov_id = (SELECT mov_id FROM movie 
WHERE mov_title = 'Annie Hall'));

--2. write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut'. Return director first name, last name.
SELECT dir_fname, dir_lname FROM director 
WHERE dir_id = (SELECT dir_id FROM movie_direction 
WHERE mov_id = (SELECT mov_id FROM movie 
WHERE mov_title = 'Eyes Wide Shut'));

--3. write a SQL query to find those movies, which released in the country besides UK. Return movie title, movie year, movie time, date of release, releasing country.
SELECT mov_title, mov_year, mov_time, mov_dt_rel, mov_rel_country  FROM movie 
WHERE mov_rel_country <> 'UK';

--4. write a SQL query to find those movies where reviewer is unknown. Return movie title, year, release date, director first name, last name, actor first name, last name.
SELECT mov_title, mov_year, mov_dt_rel, dir_fname, dir_lname, act_fname, act_lname
FROM movie a, movie_direction b, director c, rating d, reviewer e, actor f, movie_cast g
WHERE a.mov_id=b.mov_id
AND  b.dir_id=c.dir_id 
AND a.mov_id=d.mov_id 
AND  d.rev_id=e.rev_id 
AND  a.mov_id=g.mov_id 
AND g.act_id=f.act_id 
AND e.rev_name LIKE '';

--5. write a SQL query to find those movies directed by the director whose first name is ‘Woody’ and last name is ‘Allen’. Return movie title. 
SELECT mov_title FROM movie 
WHERE mov_id IN (SELECT mov_id FROM movie_direction 
WHERE dir_id IN (SELECT dir_id FROM director 
WHERE dir_fname = 'Woody' AND dir_lname = 'Allen'));

--6. write a SQL query to find those years, which produced at least one movie and that, received a rating of more than three stars. Sort the result-set in ascending order by movie year. Return movie year.
SELECT DISTINCT mov_year FROM movie 
WHERE mov_id IN (SELECT mov_id FROM rating 
WHERE rev_stars > 3) ORDER BY mov_year;

--7. write a SQL query to find those movies, which have no ratings. Return movie title.
SELECT mov_title FROM movie 
WHERE mov_id IN (SELECT mov_id FROM rating 
WHERE num_o_ratings IS NULL);

--8. write a SQL query to find those reviewers who have rated nothing for some movies. Return reviewer name.
SELECT rev_name FROM reviewer 
WHERE rev_id NOT IN (SELECT DISTINCT rev_id FROM rating);

--9. write a SQL query to find those movies, which reviewed by a reviewer and got a rating. Sort the result-set in ascending order by reviewer name, movie title, review Stars. Return reviewer name, movie title, review Stars.
SELECT rev_name, mov_title, rev_stars FROM reviewer A, movie B, rating C 
WHERE B.mov_id IN (SELECT mov_id FROM rating 
WHERE rev_stars > 0)
AND A.rev_id IN (SELECT rev_id FROM rating 
WHERE rev_stars > 0)
AND C.mov_id = B.mov_id
AND C.rev_id = A.rev_id
ORDER BY rev_name, mov_title, rev_stars;

--10. write a SQL query to find those reviewers who rated more than one movie. Group the result set on reviewer’s name, movie title. Return reviewer’s name, movie title.
SELECT rev_name, mov_title FROM reviewer A, movie B 
WHERE A.rev_id IN (SELECT rev_id FROM rating 
GROUP BY rev_id HAVING COUNT(rev_id)>1)
AND B.mov_id IN (SELECT mov_id FROM rating 
WHERE rev_id IN (SELECT rev_id FROM rating 
GROUP BY rev_id HAVING COUNT(rev_id)>1))

--11. write a SQL query to find those movies, which have received highest number of stars. Group the result set on movie title and sorts the result-set in ascending order by movie title. Return movie title and maximum number of review stars.
SELECT mov_title, rev_stars FROM movie A, rating B
WHERE A.mov_id = B.mov_id 
AND B.rev_stars = (SELECT MAX(rev_stars) FROM rating)
ORDER BY mov_title;

--12. write a SQL query to find all reviewers who rated the movie 'American Beauty'. Return reviewer name.
SELECT rev_name FROM reviewer WHERE rev_id IN (SELECT rev_id FROM rating WHERE mov_id IN (SELECT mov_id FROM movie WHERE mov_title='American Beauty'));

--13. write a SQL query to find the movies, which have reviewed by any reviewer body except by 'Paul Monks'. Return movie title.
SELECT mov_title FROM movie WHERE mov_id IN (SELECT mov_id FROM rating WHERE rev_id IN (SELECT rev_id FROM reviewer WHERE rev_name <> 'Paul Monks'));

--14. write a SQL query to find the lowest rated movies. Return reviewer name, movie title, and number of stars for those movies.
SELECT rev_name, mov_title, rev_stars FROM reviewer A, movie B, rating C 
WHERE C.rev_stars = (SELECT MIN(rev_stars) FROM rating)
AND C.mov_id = B.mov_id
AND A.rev_id = C.rev_id;

--15. write a SQL query to find the movies directed by 'James Cameron'. Return movie title.
SELECT mov_title FROM movie WHERE mov_id IN (SELECT mov_id FROM movie_direction WHERE dir_id IN (SELECT dir_id FROM director WHERE dir_fname = 'James' AND dir_lname = 'Cameron'));

--16. Write a query in SQL to find the name of those movies where one or more actors acted in two or more movies.
SELECT mov_title FROM movie WHERE mov_id IN (SELECT mov_id FROM movie_cast WHERE act_id = (SELECT act_id FROM movie_cast GROUP BY act_id HAVING COUNT(mov_id) > 1));



-- Joins

--1. write a SQL query to find the name of all reviewers who have rated their ratings with a NULL value. Return reviewer name.
SELECT R.rev_name FROM reviewer R INNER JOIN rating RAT 
ON R.rev_id = RAT.rev_id
WHERE RAT.rev_stars IS NULL;

--2. write a SQL query to find the actors who were cast in the movie 'Annie Hall'. Return actor first name, last name and role. 
SELECT A.act_fname, A.act_lname, MC.role FROM ((movie_cast MC INNER JOIN movie M ON MC.mov_id = M.mov_id) INNER JOIN actor A ON A.act_id = MC.act_id) WHERE M.mov_title = 'Annie Hall';

--3. write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut'. Return director first name, last name and movie title
SELECT D.dir_fname, D.dir_lname, M.mov_title FROM ((movie_direction MD INNER JOIN movie M ON MD.mov_id = M.mov_id) INNER JOIN director D ON MD.dir_id = D.dir_id) WHERE M.mov_title = 'Eyes Wide Shut';

--4. write a SQL query to find who directed a movie that casted a role as ‘Sean Maguire’. Return director first name, last name and movie title.
SELECT D.dir_fname, D.dir_lname, M.mov_title FROM (((movie_direction MD INNER JOIN movie M ON MD.mov_id = M.mov_id) INNER JOIN director D ON MD.dir_id = D.dir_id) INNER JOIN movie_cast MC ON MC.mov_id = M.mov_id) WHERE MC.role = 'Sean Maguire';

--5. write a SQL query to find the actors who have not acted in any movie between 1990 and 2000 (Begin and end values are included.). Return actor first name, last name, movie title and release year.
SELECT A.act_fname, A.act_lname, M.mov_title, M.mov_year FROM (
(movie_cast MC INNER JOIN movie M ON MC.mov_id = M.mov_id) 
INNER JOIN actor A ON A.act_id = MC.act_id) 
WHERE M.mov_year NOT BETWEEN 1990 AND 2000;

--6. write a SQL query to find the directors with number of genres movies. Group the result set on director first name, last name and generic title. Sort the result-set in ascending order by director first name and last name. Return director first name, last name and number of genres movies.
SELECT DISTINCT D.dir_fname, D.dir_lname, G.gen_title FROM (
((movie_genres MG INNER JOIN genres G ON G.gen_id = MG.gen_id) 
INNER JOIN movie_direction MD ON MD.mov_id = MG.mov_id) 
INNER JOIN director D ON D.dir_id = MD.dir_id)
ORDER BY D.dir_fname, D.dir_lname;

--7. write a SQL query to find the movies with year and genres. Return movie title, movie year and generic title.
SELECT M.mov_title, M.mov_year, G.gen_title FROM ((movie M LEFT JOIN movie_genres MG ON MG.mov_id = M.mov_id)INNER JOIN genres G ON MG.gen_id = G.gen_id);

--8. write a SQL query to find all the movies with year, genres, and name of the director.
SELECT M.mov_title, M.mov_year, D.dir_fname + ' ' + D.dir_lname AS [director name], G.gen_title FROM (((
(movie M INNER JOIN movie_direction MD ON M.mov_id = MD.mov_id) 
INNER JOIN director D ON D.dir_id = MD.dir_id)
INNER JOIN movie_genres MG ON MG.mov_id = M.mov_id)
INNER JOIN genres G ON G.gen_id = MG.gen_id);
 
--9. write a SQL query to find the movies released before 1st January 1989. Sort the result-set in descending order by date of release. Return movie title, release year, date of release, duration, and first and last name of the director.
SELECT M.mov_title, M.mov_year, M.mov_dt_rel, M.mov_time, D.dir_fname, D.dir_lname FROM ((movie M INNER JOIN movie_direction MD ON MD.mov_id = M.mov_id) INNER JOIN director D ON D.dir_id = MD.dir_id)
WHERE mov_dt_rel < '1989-01-01'
ORDER BY mov_dt_rel;

--10. write a SQL query to compute the average time and count number of movies for each genre. Return genre title, average time and number of movies for each genre.
SELECT G.gen_title, AVG(M.mov_time) AS [Avg Time], COUNT(M.mov_id) AS [No. of Movie] FROM ((
movie M INNER JOIN movie_genres MG ON MG.mov_id = M.mov_id)
INNER JOIN genres G ON G.gen_id = MG.gen_id)
GROUP BY G.gen_title;

--11. write a SQL query to find movies with the lowest duration. Return movie title, movie year, director first name, last name, actor first name, last name and role.
SELECT M.mov_title, M.mov_year, D.dir_fname, D.dir_lname, A.act_fname, A.act_lname, MC.role FROM ((((
movie M INNER JOIN movie_direction MD ON M.mov_id = MD.mov_id)
INNER JOIN director D ON MD.dir_id = D.dir_id)
INNER JOIN movie_cast MC ON MC.mov_id = M.mov_id)
INNER JOIN actor A ON A.act_id = MC.act_id)
WHERE M.mov_time = (SELECT MIN(mov_time) FROM movie);

--12. write a SQL query to find those years when a movie received a rating of 3 or 4. Sort the result in increasing order on movie year. Return move year. 
SELECT DISTINCT M.mov_year FROM movie M INNER JOIN rating R ON M.mov_id = R.mov_id WHERE R.rev_stars IN (3,4) ORDER BY M.mov_year;

--13. write a SQL query to get the reviewer name, movie title, and stars in an order that reviewer name will come first, then by movie title, and lastly by number of stars.
SELECT R.rev_name, M.mov_title, RAT.rev_stars FROM ((movie M INNER JOIN rating RAT ON M.mov_id = RAT.mov_id) INNER JOIN reviewer R ON R.rev_id = RAT.rev_id);

--14. write a SQL query to find those movies that have at least one rating and received highest number of stars. Sort the result-set on movie title. Return movie title and maximum review stars.
SELECT mov_title, MAX(rev_stars) AS [Review  star] FROM movie M INNER JOIN rating R ON R.mov_id = M.mov_id
GROUP BY M.mov_title 
HAVING MAX(R.rev_stars)>0
ORDER BY M.mov_title;

--15. write a SQL query to find those movies, which have received ratings. Return movie title, director first name, director last name and review stars.
SELECT mov_title, dir_fname, dir_lname, rev_stars FROM (((
movie M INNER JOIN movie_direction MD ON M.mov_id = MD.mov_id)
INNER JOIN director D ON D.dir_id = MD.dir_id)
INNER JOIN rating R ON R.mov_id = M.mov_id)
WHERE R.rev_stars IS NOT NULL;

--16. Write a query in SQL to find the movie title, actor first and last name, and the role for those movies where one or more actors acted in two or more movies. 
SELECT M.mov_title, A.act_fname, A.act_lname, MC.role FROM ((
movie M INNER JOIN movie_cast MC ON MC.mov_id = M.mov_id)
INNER JOIN actor A ON A.act_id = MC.act_id)
WHERE A.act_id IN (SELECT act_id FROM movie_cast GROUP BY act_id HAVING COUNT(mov_id) > 1);
