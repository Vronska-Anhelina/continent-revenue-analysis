SELECT sp.continent, SUM(pr.price) AS revenue, SUM(CASE WHEN pr.category='Bookcases & shelving units' THEN pr.price END) AS revenue_from_bookcases, SUM(CASE WHEN pr.category='Bookcases & shelving units' THEN pr.price END)/SUM(pr.price)*100 AS revenue_from_bookcases_percent
FROM `DA.session_params` sp
JOIN `DA.order` o
ON sp.ga_session_id=o.ga_session_id
JOIN `DA.product` pr
ON o.item_id=pr.item_id
GROUP BY sp.continent
ORDER BY revenue DESC;
