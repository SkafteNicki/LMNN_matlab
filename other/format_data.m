function [x_train, y_train, x_test_a, x_test_b] = format_data(pairs, ux, idxa, idxb, fold)
  %% Pre-specified cross-validation
  train_mask = ([pairs.fold] ~= fold);
  test_mask  = ([pairs.fold] == fold);

  %% Convert training data to labeled data
  matches = logical([pairs.match]);
  [x_train, y_train] = pairs2labels(pairs(train_mask & matches), ux);
  
  %% Extract test data
  x_test_a = ux(:, idxa(test_mask));
  x_test_b = ux(:, idxb(test_mask));
end % function

function [x_train, y_train] = pairs2labels(pairs, ux)
  imgs1 = [pairs.img1];
  imgs2 = [pairs.img2];
  
  keymat = [[imgs1.classId], [imgs2.classId]; [imgs1.id], [imgs2.id]];
  [ids, idsndx] = unique(keymat.', 'rows');
  
  x_train = ux(:, idsndx);
  y_train = consecutiveLabels(ids(:, 1).');
end % function

function ty = consecutiveLabels(y)
  uniqueLabels = unique(y);
  ty = zeros(size(y));
  for cY = 1:length(uniqueLabels)
    mask = (y == uniqueLabels(cY));
    ty(mask) = cY;
  end % for
end % function