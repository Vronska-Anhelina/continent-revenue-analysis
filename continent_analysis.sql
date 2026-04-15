
WITH continent AS(
  SELECT DISTINCT continent
  FROM `DA.session_params` sp),
  revenue AS ( --income about continents
    SELECT continent, SUM(pr.price) AS revenue
    FROM `DA.product` pr
    JOIN `DA.order` o
    ON pr.item_id=o.item_id
    JOIN `DA.session` ss
    ON ss.ga_session_id=o.ga_session_id
    JOIN `DA.session_params` sp
    ON ss.ga_session_id=sp.ga_session_id
    GROUP BY continent),
    revenue_mobile AS ( --telephone revenue
      SELECT continent,SUM(pr.price) AS     revenue_from_mobile
      FROM `DA.product` pr
    JOIN `DA.order` o
    ON pr.item_id=o.item_id
    JOIN `DA.session` ss
    ON ss.ga_session_id=o.ga_session_id
    JOIN `DA.session_params` sp
    ON ss.ga_session_id=sp.ga_session_id
    WHERE device='mobile'
    GROUP BY continent),
    revenue_desktop AS( --desktop income
    SELECT continent, SUM(pr.price) AS revenue_from_desktop
    FROM `DA.product` pr
    JOIN `DA.order` o
    ON pr.item_id=o.item_id
    JOIN `DA.session` ss
    ON ss.ga_session_id=o.ga_session_id
    JOIN `DA.session_params` sp
    ON ss.ga_session_id=sp.ga_session_id
    WHERE device='desktop'
    GROUP BY continent),
    revenue_total AS(
SELECT SUM(pr.price) AS total_revenue --income of all
 FROM `DA.product` pr
    JOIN `DA.order` o
    ON pr.item_id=o.item_id
    JOIN `DA.session` ss
    ON ss.ga_session_id=o.ga_session_id
    JOIN `DA.session_params` sp
    ON ss.ga_session_id=sp.ga_session_id),
acc_cnt AS (
  SELECT continent,COUNT (DISTINCT a.id) AS account_count --number of accounts
  FROM `DA.account`a
  JOIN `DA.account_session` acs
  ON a.id=acs.account_id
  JOIN `DA.session_params` sp
  ON acs.ga_session_id=sp.ga_session_id
  GROUP BY continent),
 verified AS( --number of verified accounts
  SELECT continent,COUNT(DISTINCT a.id) AS verified_account
  FROM `DA.account`a
  JOIN `DA.account_session` acs
  ON a.id=acs.account_id
  JOIN `DA.session_params` sp
  ON acs.ga_session_id=sp.ga_session_id
  WHERE is_verified=1
  GROUP BY continent),
  sessio_cnt AS ( --кількість сесій
    SELECT continent, COUNT(DISTINCT s.ga_session_id) AS session_cnt
    FROM `DA.session` s
    JOIN `DA.session_params` sp
    ON s.ga_session_id=sp.ga_session_id
    GROUP BY continent),
    finally AS (
      SELECT c.continent,r.revenue,rm.revenue_from_mobile,rd.revenue_from_desktop,r.revenue/tr.total_revenue*100 AS per_revenue_from_total,ac.account_count,verified_account,session_cnt
      FROM continent c
      JOIN revenue r
      ON c.continent=r.continent
      JOIN revenue_mobile rm
      ON rm.continent=c.continent
      JOIN revenue_desktop rd
      ON rd.continent=c.continent
      CROSS JOIN revenue_total tr
     JOIN verified v
     ON c.continent=v.continent
     JOIN sessio_cnt sc
     ON c.continent=sc.continent
     JOIN acc_cnt ac
     ON c.continent=ac.continent)
     SELECT continent,revenue,revenue_from_mobile,revenue_from_desktop,per_revenue_from_total,account_count,verified_account,session_cnt
     FROM finally;
