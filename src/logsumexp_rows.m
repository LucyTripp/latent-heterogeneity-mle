function result = logsumexp_rows(values)
%LOGSUMEXP_ROWS Stable row-wise log(sum(exp(values), 2)).

row_max = max(values, [], 2);
result = row_max + log(sum(exp(values - row_max), 2));

invalid_rows = ~isfinite(row_max);
result(invalid_rows) = row_max(invalid_rows);
end
