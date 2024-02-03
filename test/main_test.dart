import './mappers/task_result_mapper_test.dart' as task_result_mapper_test;
import './models/task_result_test.dart' as task_result_test;
import './execution_metrics_test.dart' as execution_metrics_test;

void main() {
  execution_metrics_test.main();
  task_result_mapper_test.main();
  task_result_test.main();
}
