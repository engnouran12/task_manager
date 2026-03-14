import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/models/task/task_model.dart';

/// Central place for all static mock data used across the app.
class MockData {
  // ── Admin / logged-in user ────────────────────────────────────────────
  static const String adminFirstName = 'Sarah';
  static const String adminLastName = 'Johnson';
  static const String adminRole = 'Admin';

  // ── Employees (avatars use initials / colours) ───────────────────────
  static const List<Map<String, String>> employees = [
    {'name': 'Ali Hassan', 'initials': 'AH', 'color': '0xff704264', 'id': 'e1'},
    {'name': 'Mona Saad', 'initials': 'MS', 'color': '0xff411738', 'id': 'e2'},
    {'name': 'Omar Fathy', 'initials': 'OF', 'color': '0xff9C27B0', 'id': 'e3'},
    {'name': 'Nour Khaled', 'initials': 'NK', 'color': '0xff00796B', 'id': 'e4'},
    {'name': 'Reem Adel', 'initials': 'RA', 'color': '0xffE64A19', 'id': 'e5'},
    {'name': 'Tarek Nabil', 'initials': 'TN', 'color': '0xff1565C0', 'id': 'e6'},
    {'name': 'Dina Mostafa', 'initials': 'DM', 'color': '0xff558B2F', 'id': 'e7'},
  ];

  // ── Projects ─────────────────────────────────────────────────────────
  static final List<ProjectModel> projects = [
    ProjectModel(
      id: '1',
      name: 'Mobile App Redesign',
      status: 'inprogress',
      priority: 'high',
      description:
          'Redesign the entire mobile application UI/UX to improve usability, '
          'accessibility, and visual consistency across all platforms. Includes '
          'new design system, component library, and user testing.',
      hidden: false,
      managerId: 'mgr1',
      employees: ['e1', 'e2', 'e3'],
      dueDate: DateTime.now().add(const Duration(days: 12)),
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '2',
      name: 'API Integration',
      status: 'todo',
      priority: 'medium',
      description:
          'Connect all screens to the backend REST API. Implement proper '
          'error handling, retry logic, and caching strategies.',
      hidden: false,
      managerId: 'mgr1',
      employees: ['e4', 'e5'],
      dueDate: DateTime.now().add(const Duration(days: 25)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '3',
      name: 'QA & Testing',
      status: 'completed',
      priority: 'low',
      description:
          'Full regression and UAT testing for v1.0 release. Covers unit, '
          'integration, and end-to-end automated test suites.',
      hidden: false,
      managerId: 'mgr2',
      employees: ['e6', 'e7'],
      dueDate: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '4',
      name: 'Backend Refactor',
      status: 'inprogress',
      priority: 'high',
      description:
          'Refactor Node.js backend services to follow clean architecture. '
          'Migrate to microservices, improve performance, and add monitoring.',
      hidden: false,
      managerId: 'mgr1',
      employees: ['e1', 'e6'],
      dueDate: DateTime.now().add(const Duration(days: 18)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '5',
      name: 'Dashboard Analytics',
      status: 'todo',
      priority: 'medium',
      description:
          'Build admin analytics dashboard with charts, KPIs, and exportable '
          'reports. Integrate with BI tools and live data streams.',
      hidden: false,
      managerId: 'mgr2',
      employees: ['e2', 'e4'],
      dueDate: DateTime.now().add(const Duration(days: 40)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
  ];

  // ── Progress values per project id ───────────────────────────────────
  static const Map<String, double> projectProgress = {
    '1': 0.65,
    '2': 0.10,
    '3': 1.00,
    '4': 0.42,
    '5': 0.05,
  };

  // ── Tasks per project ─────────────────────────────────────────────────
  static final List<TaskModel> tasks = [
    // Project 1 – Mobile App Redesign
    TaskModel(id: 't1', projectId: '1', name: 'Create Design System', description: 'Define colours, typography, spacing tokens.', priority: 'high', employeeId: 'e1', done: true, hidden: false, date: DateTime.now().add(const Duration(days: 5)), createdat: DateTime.now().subtract(const Duration(days: 18)), updatedat: DateTime.now()),
    TaskModel(id: 't2', projectId: '1', name: 'Redesign Login Flow', description: 'Wireframe and prototype new login/register screens.', priority: 'high', employeeId: 'e2', done: true, hidden: false, date: DateTime.now().add(const Duration(days: 7)), createdat: DateTime.now().subtract(const Duration(days: 15)), updatedat: DateTime.now()),
    TaskModel(id: 't3', projectId: '1', name: 'Home Screen Mockup', description: 'Create high-fidelity mockup for the home dashboard.', priority: 'medium', employeeId: 'e3', done: false, hidden: false, date: DateTime.now().add(const Duration(days: 10)), createdat: DateTime.now().subtract(const Duration(days: 10)), updatedat: DateTime.now()),
    TaskModel(id: 't4', projectId: '1', name: 'User Testing Round 1', description: 'Conduct usability tests with 5 participants.', priority: 'low', employeeId: 'e1', done: false, hidden: false, date: DateTime.now().add(const Duration(days: 12)), createdat: DateTime.now().subtract(const Duration(days: 8)), updatedat: DateTime.now()),

    // Project 2 – API Integration
    TaskModel(id: 't5', projectId: '2', name: 'Auth Endpoints', description: 'Integrate login, logout and token refresh.', priority: 'high', employeeId: 'e4', done: false, hidden: false, date: DateTime.now().add(const Duration(days: 14)), createdat: DateTime.now().subtract(const Duration(days: 9)), updatedat: DateTime.now()),
    TaskModel(id: 't6', projectId: '2', name: 'Projects API', description: 'Connect projects list, create and delete endpoints.', priority: 'medium', employeeId: 'e5', done: false, hidden: false, date: DateTime.now().add(const Duration(days: 18)), createdat: DateTime.now().subtract(const Duration(days: 7)), updatedat: DateTime.now()),

    // Project 3 – QA & Testing
    TaskModel(id: 't7', projectId: '3', name: 'Write Unit Tests', description: 'Cover all cubit and service classes with unit tests.', priority: 'medium', employeeId: 'e6', done: true, hidden: false, date: DateTime.now().subtract(const Duration(days: 5)), createdat: DateTime.now().subtract(const Duration(days: 28)), updatedat: DateTime.now()),
    TaskModel(id: 't8', projectId: '3', name: 'Integration Tests', description: 'End-to-end test for all primary user flows.', priority: 'high', employeeId: 'e7', done: true, hidden: false, date: DateTime.now().subtract(const Duration(days: 2)), createdat: DateTime.now().subtract(const Duration(days: 25)), updatedat: DateTime.now()),

    // Project 4 – Backend Refactor
    TaskModel(id: 't9', projectId: '4', name: 'Extract Auth Service', description: 'Move auth logic into standalone microservice.', priority: 'high', employeeId: 'e6', done: true, hidden: false, date: DateTime.now().add(const Duration(days: 6)), createdat: DateTime.now().subtract(const Duration(days: 4)), updatedat: DateTime.now()),
    TaskModel(id: 't10', projectId: '4', name: 'Add API Gateway', description: 'Set up Kong gateway with rate limiting.', priority: 'high', employeeId: 'e1', done: false, hidden: false, date: DateTime.now().add(const Duration(days: 15)), createdat: DateTime.now().subtract(const Duration(days: 3)), updatedat: DateTime.now()),

    // Project 5 – Dashboard Analytics
    TaskModel(id: 't11', projectId: '5', name: 'KPI Widget Design', description: 'Design card widgets for key metrics display.', priority: 'low', employeeId: 'e2', done: false, hidden: false, date: DateTime.now().add(const Duration(days: 30)), createdat: DateTime.now().subtract(const Duration(days: 1)), updatedat: DateTime.now()),
  ];

  /// Returns tasks filtered by projectId
  static List<TaskModel> tasksForProject(String projectId) =>
      tasks.where((t) => t.projectId == projectId && t.hidden != true).toList();

  /// Returns a project by id
  static ProjectModel? projectById(String id) =>
      projects.cast<ProjectModel?>().firstWhere((p) => p?.id == id, orElse: () => null);

  /// Returns projects filtered by status
  static List<ProjectModel> projectsByStatus(String status) {
    if (status == 'holding') {
      return projects.where((p) => p.hidden == true).toList();
    }
    return projects.where((p) => p.hidden == false && p.status == status).toList();
  }

  /// Task count by status helper
  static Map<String, int> taskCountByStatus() {
    final counts = <String, int>{};
    for (final p in projects) {
      if (p.hidden) continue;
      final s = p.status ?? 'todo';
      counts[s] = (counts[s] ?? 0) + 1;
    }
    return counts;
  }

  /// Priority colour helper
  static String priorityLabel(String p) =>
      p == 'high' ? '🔴 High' : p == 'medium' ? '🟡 Medium' : '🟢 Low';
}
