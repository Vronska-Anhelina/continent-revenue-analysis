SELECT sp.continent AS continent,SUM(pr.price) AS revenue, SUM(CASE WHEN sp.device='mobile' THEN pr.price ELSE 0 END)/SUM(pr.price)*100 AS revenue_from_mobile_percent
FROM `DA.session_params` sp
RIGHT JOIN `DA.order` o
ON sp.ga_session_id=o.ga_session_id
LEFT JOIN `DA.product` pr
ON o.item_id=pr.item_id
GROUP BY continent
ORDER BY revenue DESC;
